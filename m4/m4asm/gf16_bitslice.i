.macro gf16_bitslice out0, out1, out2, out3, in0, in1, in2, in3
    // use out3 as tmp
    and.w \out0, \in0, #0x11111111
    and.w \out3, \in1, #0x11111111
    orr.w \out0, \out0, \out3, lsl#1
    and.w \out3, \in2,  #0x11111111
    orr.w \out0, \out0, \out3, lsl#2
    and.w \out3, \in3, #0x11111111
    orr.w \out0, \out0, \out3, lsl#3

    and.w \out1, \in1, #0x22222222
    and.w \out3, \in0, #0x22222222
    orr.w \out1, \out1, \out3, lsr#1
    and.w \out3, \in2, #0x22222222
    orr.w \out1, \out1, \out3, lsl#1
    and.w \out3, \in3, #0x22222222
    orr.w \out1, \out1, \out3, lsl#2

    and.w \out2, \in2, #0x44444444
    and.w \out3, \in0, #0x44444444
    orr.w \out2, \out2, \out3, lsr#2
    and.w \out3, \in1, #0x44444444
    orr.w \out2, \out2, \out3, lsr#1
    and.w \out3, \in3, #0x44444444
    orr.w \out2, \out2, \out3, lsl#1

    and.w \out3, \in3, #0x88888888
    // in3 no longer needed; use as tmp
    and.w \in3, \in0, #0x88888888
    orr.w \out3, \out3, \in3, lsr#3
    and.w \in3, \in1, #0x88888888
    orr.w \out3, \out3, \in3, lsr#2
    and.w \in3, \in2, #0x88888888
    orr.w \out3, \out3, \in3, lsr#1
.endm
