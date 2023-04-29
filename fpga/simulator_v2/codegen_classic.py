########################################################
###           Code sequences for classic             ###
########################################################
   
def keygen_codegen():
    # Init
    addi(r15, r0, O)                                                        # r15 = O
    addi(r14, r0, V)                                                        # r14 = V
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
        stall(max((P2_stall-rand_state_num*12)*buffer_multiplier, 0))       # Stall (1 round AES)
    
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

    # Calculate P1*O
    addi(r1, r0, 0)                                                         # _(Loop r1)______________
    P1_O_1 = len(inst)                                                      #                         \
    addi(r2, r0, 0)                                                         # _(Loop r2)____________   |
    P1_O_2 = len(inst)                                                      #                       \  |
    load_keys(ZERO, r0, r0)                                                 # Load zeroes            | |
    addi(r3, r1, 0)                                                         # ____________________   | |
    P1_O_mul = len(inst)                                                    #                     \  | |
    mul_key_o(P1, r1, r3, O1, r3, r2)                                       # P1[r1][r3]*O[r3][r2] | | |
    addi(r3, r3, 1)                                                         # r3++                 | | |
    bne(r3, r14, P1_O_mul)                                                  # ____________________/  | |
    store_keys(P2, r1, r2)                                                  # Store to P2[r1][r2]    | |
    addi(r2, r2, 1)                                                         # r2++                   | |
    bne(r2, r15, P1_O_2)                                                    # ______________________/  |
    addi(r1, r1, 1)                                                         # r1++                     |
    bne(r1, r14, P1_O_1)                                                    # ________________________/


    # Get P3 upper
    addi(r1, r0, 0)                                                         # _(Loop r1)__________________
    P3_upper_1 = len(inst)                                                  #                             \
    addi(r2, r1, 0)                                                         # _(Loop r2)________________   |
    P3_upper_2 = len(inst)                                                  #                           \  |
    load_keys(ZERO, r0, r0)                                                 # Load zeroes                | |
    
    addi(r3, r0, 0)                                                         # _(Loop r3)__________       | |
    P3_upper_OPO_1 = len(inst)                                              #                     \      | |
    mul_key_o(P2, r3, r2, O1, r3, r1)                                       # O[r1][r3]*P2[r3][r2] |     | |
    addi(r3, r3, 1)                                                         # r3++                 |     | |
    bne(r3, r14, P3_upper_OPO_1)                                            # ____________________/      | |
    
    addi(r3, r0, 0)                                                         # _(Loop r3)__________       | |
    P3_upper_OL_1 = len(inst)                                               #                     \      | |
    mul_key_o(L, r3, r2, O1, r3, r1)                                        # O[r1][r3]*L[r3][r2]  |     | |
    addi(r3, r3, 1)                                                         # r3++                 |     | |
    bne(r3, r14, P3_upper_OL_1)                                             # ____________________/      | |

    NEXT = len(inst) + 9                                                    # _(No upper on diagonal)_   | |
    beq(r2, r1, NEXT)                                                       #                         \  | |
    
    addi(r3, r0, 0)                                                         # _(Loop r3)__________     | | |
    P3_upper_OPO_2 = len(inst)                                              #                     \    | | |
    mul_key_o(P2, r3, r1, O1, r3, r2)                                       # O[r2][r3]*L[r3][r1]  |   | | |
    addi(r3, r3, 1)                                                         # r3++                 |   | | |
    bne(r3, r14, P3_upper_OPO_2)                                            # ____________________/    | | |
    
    addi(r3, r0, 0)                                                         # _(Loop r3)__________     | | |
    P3_upper_OL_2 = len(inst)                                               #                     \    | | |
    mul_key_o(L, r3, r1, O1, r3, r2)                                        # O[r2][r3]*L[r3][r1]  |   | | |
    addi(r3, r3, 1)                                                         # r3++                 |   | | |
    bne(r3, r14, P3_upper_OL_2)                                             # ____________________/___/  | |

    store_keys(P3, r1, r2)                                                  # Store to P3[r1][r2]        | |
    addi(r2, r2, 1)                                                         # r2++                       | |
    bne(r2, r15, P3_upper_2)                                                # __________________________/  |
    addi(r1, r1, 1)                                                         # r1++                         |
    bne(r1, r15, P3_upper_1)                                                # ____________________________/


    # Re-generate P2
    addi(r10, r0, P2_start_ctr)                                             # r10 = P2_start_ctr
    aes_set_ctr(r0, r10, 0)                                                 # aes128ctr = P1_start_ctr
    if (O == 44):                                                           # Ip, special case
        aes_update_ctr((2<<16)|(O*rand_state_num*buffer_multiplier//N+1))   # Generate 8*imm bytes 
    else:                                                                   # 
        aes_update_ctr(O*rand_state_num*buffer_multiplier//N)               # Generate 8*imm bytes
    if use_pipelined_aes:                                                   #
        stall(aes_round+3)                                                  # Stall (pipelined AES)
    else:                                                                   #
        stall(max((P2_stall-rand_state_num*12)*buffer_multiplier, 0))       # Stall (1 round AES)
    
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
        stall(max((O - (math.ceil(V/bank)+N+5)), 0))                        # wait for transpose         | |
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
        stall(max((O - (math.ceil(V/bank)+N+5)), 0))                        # wait for transpose         | |
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
    
    # eval
    load_keys(ZERO, r0, r0)                                                 # Load zeroes                 
    eval(P1)                                                                # s^T P1 s
    eval(P2)                                                                # s^T P2 s
    eval(P3)                                                                # s^T P3 s

    addi(r1, r0, O)                                                         # r1 = O
    unload_check(r1)                                                        # Compare s^T P s with t
    stall(4*(right_delay+up_delay+1))                                       # Wait for check

    finish()                                                                # End of Verify