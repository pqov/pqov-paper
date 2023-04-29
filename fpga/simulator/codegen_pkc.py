########################################################
###           Code sequences for pkc                 ###
########################################################

def keygen_codegen():
    # Init
    addi(r15, r0, O)                                                        # r15 = O
    addi(r14, r0, V)                                                        # r14 = V
    addi(r13, r0, rand_state_num-1)                                         # r13 = 3
    addi(r12, r0, rand_state_num)                                           # r12 = 4
    addi(r11, r0, rand_state_num*buffer_multiplier)                         # r11 = 4*buffer_multiplier

    # prepare for O matrix
    sha_hash_sk(sk_cnt)                                                     # Hash out O matrix
    stall(sk_stall-(O_+3)*O)                                                # Stall long enough to start
                                                                            # Storing O
    addi(r1, r0, 0)                                                         # _(Loop r1)______________
    Sample_O = len(inst)                                                    #                         \
    store_o(r1)                                                             # Store to r1 column of O  |
    addi(r1, r1, 1)                                                         # r1++                     |
    bne(r1, r15, Sample_O)                                                  # ________________________/

    aes_init_key()                                                          # Sample pk_seed and init key
    aes_set_round(aes_round)                                                # Set aes round
    

    # Generate P1
    addi(r10, r0, P1_start_ctr)                                             # r10 = P1_start_ctr
    aes_set_ctr(r0, r10, 0)                                                 # aes128ctr = P1_start_ctr
    aes_update_ctr(O*rand_state_num*buffer_multiplier//N)                   # Generate 8*imm bytes
    if use_pipelined_aes:                                                   #
        stall(aes_round+3)                                                  # Stall (pipelined AES)
    else:                                                                   #
        stall(max((P1_stall-rand_state_num*12)*buffer_multiplier, 0))       # Stall (1 round AES)
    
    addi(r3, r0, 0)                                                         # r3 = 0
    addi(r1, r0, 0)                                                         # _(Loop r1)_______________
    Generate_P1_1 = len(inst)                                               #                          \
    addi(r2, r1, 0)                                                         # _(Loop r2)_____________   |
    Generate_P1_2 = len(inst)                                               #                        \  |
    Here = len(inst) + 6                                                    # _(Regenerate P1)_____   | |
    bne(r3, r11, Here)                                                      #                      \  | |
    addi(r10, r10, O*rand_state_num*buffer_multiplier//N)                   # Increase r10          | | |
    aes_set_ctr(r0, r10, 0)                                                 # Set r10 to aes128ctr  | | |
    aes_update_ctr(O*rand_state_num*buffer_multiplier//N)                   # Generate 8*imm bytes  | | |
    if use_pipelined_aes:                                                   #                       | | |
        stall(aes_round+3)                                                  # Stall (pipelined AES) | | |
    else:                                                                   #                       | | |
        stall(max((P1_stall-rand_state_num*12)*buffer_multiplier, 0))       # Stall (1 round AES)   | | |
    addi(r3, r0, 0)                                                         # _____________________/  | |
    send()                                                                  # send O bytes            | |
    store_keys(P1, r1, r2)                                                  # Store to P1[r1][r2]     | |
    addi(r3, r3, 1)                                                         # r3++                    | |
    addi(r2, r2, 1)                                                         # r2++                    | |
    bne(r2, r14, Generate_P1_2)                                             # _______________________/  |
    addi(r1, r1, 1)                                                         # r1++                      |
    bne(r1, r14, Generate_P1_1)                                             # _________________________/


    # Calculate P3 = Upper(O^T*((P1^T)*O+P2))
    #
    # Process this way:
    # Generate 4 columns of P2. Compute P3 related to these 4 columns.
    # And accumulate to the right place of P3.
    #
    #
    #              _ r4: Actual column of P2
    #             |  _ r1: start of the sliced column
    # P2:         | |   
    #      /______V_V_____\
    #     /|  |  |  |  |  |
    #      |  |  |  |  |  |
    #      |  |  |  |  |  |
    #      |  |  |  |  |  |
    #  r2  |  |  |  |  |  |
    #      |  |  |  |  |  |
    #      |  |  |  |  |  |
    #      |  |  |  |  |  |
    #     \|__|__|__|__|__|
    #      \r5/
    #        ^
    #        |_ which column in that sliced column
    # 
    # r8: track the counter related column of P2 in aes128ctr
    # r3: track the counter related row of P2 in aes128ctr

    addi(r1, r0, 0)                                                         # _(Loop r1)_____________________
    addi(r8, r0, 0)                                                         # r8 = 0                         \
    gen_rand_outer_col = len(inst)                                          #                                 |
    
    addi(r2, r0, 0)                                                         # ________________________
    addi(r3, r8, 0)                                                         # r3 = r8                 \       |
    aes_set_ctr(r0, r3, P2_start_ctr)                                       # Set r3 to aes128ctr      |      |
    if O == 44:                                                             # Ip, special case         |      |
        aes_update_ctr((2<<16)|(O*rand_state_num//N+1))                     # Generate 8*imm bytes     |      |
        if use_pipelined_aes:                                               #                          |      |
            stall(aes_round+3)                                              # Stall for O bytes        |      |
        else:                                                               #                          |      |
            stall((aes_round+3)*(math.ceil(O/N)+1))                         # Stall for O bytes        |      |
    else:                                                                   #                          |      |
        aes_update_ctr(O*rand_state_num//N)                                 # Generate 8*imm bytes     |      |
        if use_pipelined_aes:                                               #                          |      |
            stall(aes_round+3)                                              # Stall for O bytes        |      |
        else:                                                               #                          |      |
            stall((aes_round+3)*(math.ceil(O/N)))                           # Stall for O bytes        |      |
    gen_rand_row = len(inst)                                                #                          |      |
    addi(r4, r1, 0)                                                         # r4 = r1                  |      |
    addi(r5, r0, 0)                                                         # _(Loop r5)____________   |      |
    gen_rand_col_and_calculate = len(inst)                                  #                       \  |      |
    send()                                                                  # send O bytes           | |      |
    pre_generate_key_end = len(inst) + 4                                    # _____________          | |      |
    bne(r5, r13, pre_generate_key_end)                                      #              \         | |      |
    addi(r3, r3, O*O//N)                                                    # Increment r3  |        | |      |
    aes_set_ctr(r0, r3, P2_start_ctr)                                       # for next row  |        | |      |
    if O == 44:                                                             # of aes128ctr, |        | |      |
        aes_update_ctr((2<<16)|(O*rand_state_num//N+1))                     # and start     |        | |      |
    else:                                                                   # generation.   |        | |      |
        aes_update_ctr(O*rand_state_num//N)                                 # _____________/         | |      |
    addi(r6, r0, 0)                                                         # _(Loop r6)__________   | |      |
    P2_mul = len(inst)                                                      #                     \  | |      |
    skip_Trans_mul = len(inst) + 2                                          #                      | | |      |
    bgt(r6, r2, skip_Trans_mul)                                             # Only upper of P1     | | |      |
    mul_key_o(P1, r6, r2, O1, r6, r4)                                       # P1[r6][r2]*O[r6][r4] | | |      |
    addi(r6, r6, 1)                                                         # r6++                 | | |      |
    bne(r6, r14, P2_mul)                                                    # ____________________/  | |      |
    store_keys(L, r2, r5)                                                   # Store to L[r2][r5]     | |      |
    addi(r4, r4, 1)                                                         # r4++                   | |      |
    addi(r5, r5, 1)                                                         # r5++                   | |      |
    bne(r5, r12, gen_rand_col_and_calculate)                                # ______________________/  |      |
    addi(r2, r2, 1)                                                         # r2++                     |      |
    bne(r2, r14, gen_rand_row)                                              # ________________________/       |
    
    addi(r2, r0, 0)                                                         # _(Loop r2)___________________   |
    O1_mul_P_row = len(inst)                                                #                              \  |
    addi(r3, r1, 0)                                                         # r3: actual col of P2          | |
    addi(r4, r0, 0)                                                         # _(Loop r4)_________________   | |
    O1_mul_P_col = len(inst)                                                #                            \  | |
    addi(r5, r0, 0)                                                         # _(Loop r5)_______________   | | |
    O1_mul_P_inner = len(inst)                                              #                          \  | | |
    O1_mul_P_case2 = len(inst) + 5                                          #                           | | | |
    O1_mul_P_end = len(inst) + 8                                            #                           | | | |
    bgt(r2, r3, O1_mul_P_case2)                                             # _(Skip when r2=r3)_____   | | | |
    load_keys(P3, r2, r3)                                                   # Load from P3[r2][r3]   \  | | | |
    mul_key_o(L, r5, r4, O1, r5, r2)                                        # O1[r5][r2]*P1O1[r5][r4] | | | | |
    store_keys(P3, r2, r3)                                                  # Store to P3[r2][r3]     | | | | |
    beq(r0, r0, O1_mul_P_end)                                               # _(Skip when r2=r3)_____/  | | | |
    load_keys(P3, r3, r2)                                                   # Load from P3[r3][r2]      | | | |
    mul_key_o(L, r5, r4, O1, r5, r2)                                        # O1[r5][r2]*P1O1[r5][r4]   | | | |
    store_keys(P3, r3, r2)                                                  # Store to P3[r3][r2]       | | | |
    addi(r5, r5, 1)                                                         # r5++                      | | | |
    bne(r5, r14, O1_mul_P_inner)                                            # _________________________/  | | |
    addi(r3, r3, 1)                                                         # r3++                        | | |
    addi(r4, r4, 1)                                                         # r4++                        | | |
    bne(r4, r12, O1_mul_P_col)                                              # ___________________________/  | |
    addi(r2, r2, 1)                                                         # r2++                          | |
    bne(r2, r15, O1_mul_P_row)                                              # _____________________________/  |

    addi(r1, r1, rand_state_num)                                            # r1+=4                           |
    addi(r8, r8, O*rand_state_num//N)                                       # Increment r8                    |
    bne(r1, r15, gen_rand_outer_col)                                        # _______________________________/


    # Generate P2
    addi(r10, r0, P2_start_ctr)                                             # r10 = P2_start_ctr
    aes_set_ctr(r0, r10, 0)                                                 # aes128ctr = P1_start_ctr
    if (O == 44):                                                           # Ip, special case
        aes_update_ctr((2<<16)|(O*rand_state_num*buffer_multiplier//N+1))   # Generate 8*imm bytes 
    else:                                                                   # 
        aes_update_ctr(O*rand_state_num*buffer_multiplier//N)               # Generate 8*imm bytes
    if use_pipelined_aes:                                                   #
        stall(aes_round+3)                                                  # Stall (pipelined AES)
    else:                                                                   #
        stall(max((P2_stall-rand_state_num*10)*buffer_multiplier, 0))       # Stall (1 round AES)
    
    addi(r3, r0, 0)                                                         # r3 = 0
    addi(r1, r0, 0)                                                         # _(Loop r1)_______________
    Generate_P2_1 = len(inst)                                               #                          \
    addi(r2, r0, 0)                                                         # _(Loop r2)_____________   |
    Generate_P2_2 = len(inst)                                               #                        \  |
    Here = len(inst) + 6                                                    # _(Regenerate P2)_____   | |
    bne(r3, r11, Here)                                                      #                      \  | |
    addi(r10, r10, O*rand_state_num*buffer_multiplier//N)                   # Increase r10          | | |
    aes_set_ctr(r0, r10, 0)                                                 # Set r10 to aes128ctr  | | |
    if (O == 44):                                                           # Ip, special case      | | |
        aes_update_ctr((2<<16)|(O*rand_state_num*buffer_multiplier//N+1))   # Generate 8*imm bytes  | | |
    else:                                                                   #                       | | |
        aes_update_ctr(O*rand_state_num*buffer_multiplier//N)               # Generate 8*imm bytes  | | |
    if use_pipelined_aes:                                                   #                       | | |
        stall(aes_round+3)                                                  # Stall (pipelined AES) | | |
    else:                                                                   #                       | | |
        stall(max((P2_stall-rand_state_num*12)*buffer_multiplier, 0))       # Stall (1 round AES)   | | |
    addi(r3, r0, 0)                                                         # _____________________/  | |
    send()                                                                  # send O bytes            | |
    store_keys(P2, r1, r2)                                                  # Store to P2[r1][r2]     | |
    addi(r3, r3, 1)                                                         # r3++                    | |
    addi(r2, r2, 1)                                                         # r2++                    | |
    bne(r2, r15, Generate_P2_2)                                             # _______________________/  |
    addi(r1, r1, 1)                                                         # r1++                      |
    bne(r1, r14, Generate_P2_1)                                             # _________________________/


    # Calculate L = (P1T + P1)*O + P2
    addi(r1, r0, 0)                                                         # _(Loop r1)______________
    L_1 = len(inst)                                                         #                         \
    addi(r2, r0, 0)                                                         # _(Loop r2)____________   |
    L_2 = len(inst)                                                         #                       \  |
    load_keys(P2, r1, r2)                                                   # Load from P2[r1][r2]   | |
    mul_key_o_pipe(P1, r1, r0, O1, r0, r2)                                  # (P1T+P1)*O (pipelined) | |
    store_keys(L, r1, r2)                                                   # Store to L[r1][r2]     | |
    addi(r2, r2, 1)                                                         # r2++                   | |
    bne(r2, r15, L_2)                                                       # ______________________/  |
    addi(r1, r1, 1)                                                         # r1++                     |
    bne(r1, r14, L_1)                                                       # ________________________/


    finish()                                                                # End of KeyGen

def sign_codegen():
    # Init
    addi(r15, r0, O)                                                        # r15 = O
    addi(r14, r0, V)                                                        # r14 = V
    addi(r6, r0, math.ceil(O/N))                                            # r6 = O/N
    addi(r5, r0, math.ceil(V/N))                                            # r5 = V/N

    sha_hash_m()                                                            # Hash(M|salt)
    stall(24*(math.ceil(O*GF_bit/1088)) + O*GF_bit//64 + 3)                 # Wait for digest

    if use_inversion:
        # Calculate L and Gauss
        Sign_start = len(inst)                                              # _(Loop ctr)_________________
        sha_hash_v()                                                        # Hash(M|salt|seed|ctr)       \
        stall(24*(math.ceil(V*GF_bit/1088)) + V*GF_bit//64 + 3)             # Wait for digest              |
        addi(r1, r0, 0)                                                     # _(Loop r1)________________   |
        calc_column_loop = len(inst)                                        #                           \  |
        load_keys(ZERO, r0, r0)                                             # Load zeroes                | |
        calc_l(L, r0, r1)                                                   # Calculate r1 col of v^T*L  | |
        store_l(r1)                                                         # Store to col of L to L_mem | |
        addi(r1, r1, 1)                                                     # r1++                       | |
        bne(r1, r15, calc_column_loop)                                      # __________________________/  |
        gauss_elim(Sign_start)                                              # _Start matrix innversion____/

        # eval P1
        load_keys(ZERO, r0, r0)                                             # Load zeroes
        eval(P1)                                                            # s^T P1 s
        unload_add_y()                                                      # Shift data out
        stall(O_)                                                           # Wait for shifting

        addi(r1, r0, 0)                                                     # _(Loop r1)________________
        Mul_Invf = len(inst)                                                #                           \
        addi(r3, r0, 0)                                                     # _(Loop r3)____________     |
        load_keys(ZERO, r0, r0)                                             # Load zeroes           \    |
        Mul_Invf_loop = len(inst)                                           #                        |   |
        mul_l_inv(0, r1, r3)                                                # L^-1[r1][r3]*(t-y)[r3] |   |
        addi(r3, r3, 1)                                                     # r3++                   |   |
        bne(r3, r6, Mul_Invf_loop)                                          # _col of L^-1__________/    |
        store_sig_o(r1)                                                     # Store subvector x          |
        addi(r1, r1, 1)                                                     # r1++                       |
        bne(r1, r6, Mul_Invf)                                               # _row of L^-1______________/

    else:
        # Calculate L and Gauss
        Sign_start = len(inst)                                              # _(Loop ctr)_________________
        sha_hash_v()                                                        # Hash(M|salt|seed|ctr)       \
        stall(24*(math.ceil(V*GF_bit/1088)) + V*GF_bit//64 + 3)             # Wait for digest              |
        
        # eval P1
        load_keys(ZERO, r0, r0)                                             # Load zeroes                  |
        eval(P1)                                                            # v^T P1 v                     |
        unload_add_y()                                                      # Shift out result y           |
        stall(O_)                                                           # Wait for shifting            |

        addi(r1, r0, 0)                                                     # _(Loop r1)________________   |
        calc_column_loop = len(inst)                                        #                           \  |
        load_keys(ZERO, r0, r0)                                             # Load zeroes                | |
        calc_l(L, r0, r1)                                                   # Calculate r1 col of v^T*L  | |
        store_l(r1)                                                         # Store to col of L to L_mem | |
        addi(r1, r1, 1)                                                     # r1++                       | |
        bne(r1, r15, calc_column_loop)                                      # __________________________/  |
        stall(O_*N + 2*(right_delay+up_delay+1) + O_)                       # Wait for store_l             |
        gauss_elim(Sign_start)                                              # _Start Gaussian elimination_/

    addi(r1, r0, 0)                                                         # _(Loop r1)_______________
    Mul_T = len(inst)                                                       #                          \
    addi(r2, r0, 0)                                                         # _(Loop r2)____________    |
    load_keys(ZERO, r0, r0)                                                 # Load zeroes           \   |
    Mul_T_loop = len(inst)                                                  #                        |  |
    mul_o(0, r1, r2)                                                        # O[r1][r2]*x[r2]        |  |
    addi(r2, r2, 1)                                                         # r2++                   |  |
    bne(r2, r6, Mul_T_loop)                                                 # ______________________/   |
    add_to_sig_v(r1)                                                        # Subecvector r1 of v+Ox    |
    addi(r1, r1, 1)                                                         # r1++                      |
    bne(r1, r5, Mul_T)                                                      # _________________________/

    stall(4*(right_delay+up_delay+1))                                       # Wait for add_to_sig_v

    if use_tower_field:                                                     # Output signature to AES field
        addi(r1, r0, 0)                                                     # ______________________________
        addi(r2, r0, V_+O_)                                                 # V_+O_: number of subvectors   \
        TOWER_to_AES_loop = len(inst)                                       #                                |
        tower_to_aes(r1)                                                    # Tower to AES subvector r1 of s |
        addi(r1, r1, 1)                                                     # r1++                           |
        bne(r1, r2, TOWER_to_AES_loop)                                      # ______________________________/
        stall(2)                                                            # Wait for tower_to_aes

    finish()                                                                # End of Sign

def vrfy_codegen():
    # Init
    addi(r15, r0, O)                                                        # r15 = O
    addi(r14, r0, V)                                                        # r14 = V
    addi(r11, r0, rand_state_num*buffer_multiplier)                         # r11 = 4*buffer_multiplier

    if use_tower_field:                                                     # Input signature to Tower field
        addi(r1, r0, 0)                                                     # ______________________________
        addi(r2, r0, V_+O_)                                                 # V_+O_: number of subvectors   \
        AES_to_TOWER_loop = len(inst)                                       #                                |
        aes_to_tower(r1)                                                    # AES to Tower subvector r1 of s |
        addi(r1, r1, 1)                                                     # r1++                           |
        bne(r1, r2, AES_to_TOWER_loop)                                      # ______________________________/
        stall(2)                                                            # Wait for aes_to_tower

    sha_hash_m()                                                            # Hash(M|salt)
    stall(24*(math.ceil(O*GF_bit/1088)) + O*GF_bit//64 + 3)                 # Wait for digest
    
    aes_init_key()                                                          # Sample pk_seed and init key
    aes_set_round(aes_round)                                                # Set aes round

    # eval P1
    load_keys(ZERO, r0, r0)                                                 # Load zeroes
    addi(r10, r0, P1_start_ctr)                                             # r10 = P1_start_ctr
    aes_set_ctr(r0, r10, 0)                                                 # aes128ctr = P1_start_ctr
    aes_update_ctr(O*rand_state_num*buffer_multiplier//N)                   # Generate 8*imm bytes
    eval(P3)                                                                # (s^T P3 T) while waiting aes
    if not use_pipelined_aes:                                               #
        stall(max((P1_stall-rand_state_num*O_)*buffer_multiplier+20-(O*(O+1)//2), 0)) # Stall for AES or eval
    
    cur_row = 0
    cur_col = 0
    cnt     = 1
    addi(r1, r0, 0)
    addi(r2, r0, 0)
    while True:
        mul_key_sig(P1, r1, r2, rand_state_num*buffer_multiplier)
        break_loop = False
        for r in range(V):
            if break_loop:
                break
            for c in range(r, V):
                idx2 = ((V+V-(r-1))*r)//2 + (c-r)
                idx1 = ((V+V-(cur_row-1))*cur_row)//2 + (cur_col-cur_row)
                if (idx2 - idx1) == rand_state_num*buffer_multiplier:
                    addi(r1, r0, r)
                    addi(r2, r0, c)
                    cur_row = r
                    cur_col = c
                    break_loop = True
                    break
        if not break_loop:
            break
        cnt += 1
        addi(r10, r10, O*rand_state_num*buffer_multiplier//N)               # Increase r10        \  | |
        aes_set_ctr(r0, r10, 0)                                             # Set r10 to aes128ctr | | |
        aes_update_ctr(O*rand_state_num*buffer_multiplier//N)               # Generate 8*imm bytes | | |
        if use_pipelined_aes:                                               #                      | | |
            stall(aes_round+3)                                              # Stall for O bytes    | | |
        else:                                                               #                      | | |
            stall(max((P1_stall-rand_state_num*O_)*buffer_multiplier, 0)+20)# Stall for O bytes    | | |
    stall((O*rand_state_num*buffer_multiplier*GF_bit*cnt - V*(V+1)//2*GF_bit*O)//128) # wait aes to finish                                                     # wait aes to finish
    
    # Generate P2
    addi(r10, r0, P2_start_ctr)                                             # r10 = P2_start_ctr
    aes_set_ctr(r0, r10, 0)                                                 # aes128ctr = P2_start_ctr
    if (O == 44):                                                           #
        aes_update_ctr((2<<16)|(O*O//N+1))                                  # Generate 8*imm bytes
    else:                                                                   #
        aes_update_ctr(O*O//N)                                              # Generate 8*imm bytes
    if use_pipelined_aes:                                                   #
        stall(aes_round+3)                                                  # Stall (pipelined AES)
    else:                                                                   #
        stall(max(P2_stall*(O//rand_state_num)-O*O_+20, 0))                 # Stall (1 round AES)
    
    addi(r1, r0, 0)                                                         # _(Loop r1)______________
    addi(r2, r0, 0)                                                         #                         \
    Vrfy_P2_1 = len(inst)                                                   #                          |
    mul_key_sig(P2, r1, r2, O)                                              # (s^T P2[r1][r2] T)       |
    addi(r10, r10, O*O//N)                                                  # Increase r10             |
    aes_set_ctr(r0, r10, 0)                                                 # Set r10 to aes128ctr     |
    if (O == 44):                                                           #                          |
        aes_update_ctr((2<<16)|(O*O//N+1))                                  # Generate 8*imm bytes     |
    else:                                                                   #                          |
        aes_update_ctr(O*O//N)                                              # Generate 8*imm bytes     |
    if use_pipelined_aes:                                                   #                          |
        stall(aes_round+3)                                                  # Stall (pipelined AES)    |
    else:                                                                   #                          |
        stall(max(P2_stall*(O//rand_state_num)-O*O_+20, 0))                 # Stall (1 round AES)      |
    addi(r1, r1, 1)                                                         # r1++                     |
    bne(r1, r14, Vrfy_P2_1)                                                 # ________________________/
    
    addi(r1, r0, O)                                                         # r1 = O
    unload_check(r1)                                                        # Compare s^T P s with t
    stall(4*(right_delay+up_delay+1))                                       # Wait for check

    finish()                                                                # End of Verify