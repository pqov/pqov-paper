
.macro gf256_madd_bitsliced outf0, outf1, outf2, outf3, outf4, outf5, outf6, outf7, outr0, outr1, outr2, outr3, in0, in1, in2, in3, in4, in5, in6, in7, inf0, inf1, inf2, inf3, inf4, inf5, inf6, inf7, bb
tst.w \bb, #1
vmov.w \in0, \inf0
vmov.w \in1, \inf1
vmov.w \in2, \inf2
vmov.w \in3, \inf3
vmov.w \in4, \inf4
vmov.w \in5, \inf5
vmov.w \in6, \inf6
vmov.w \in7, \inf7
vmov.w \outr0, \outf0
vmov.w \outr1, \outf1
vmov.w \outr2, \outf2
vmov.w \outr3, \outf3
itttt ne
eorne.w \outr0, \outr0, \in0
eorne.w \outr1, \outr1, \in1
eorne.w \outr2, \outr2, \in2
eorne.w \outr3, \outr3, \in3
eor.w \in0, \in0, \in7
eor.w \in2, \in2, \in7
eor.w \in3, \in3, \in7
tst.w \bb, #2
itttt ne
eorne.w \outr0, \outr0, \in7
eorne.w \outr1, \outr1, \in0
eorne.w \outr2, \outr2, \in1
eorne.w \outr3, \outr3, \in2
eor.w \in7, \in7, \in6
eor.w \in1, \in1, \in6
eor.w \in2, \in2, \in6
tst.w \bb, #4
itttt ne
eorne.w \outr0, \outr0, \in6
eorne.w \outr1, \outr1, \in7
eorne.w \outr2, \outr2, \in0
eorne.w \outr3, \outr3, \in1
eor.w \in6, \in6, \in5
eor.w \in0, \in0, \in5
eor.w \in1, \in1, \in5
tst.w \bb, #8
itttt ne
eorne.w \outr0, \outr0, \in5
eorne.w \outr1, \outr1, \in6
eorne.w \outr2, \outr2, \in7
eorne.w \outr3, \outr3, \in0
eor.w \in5, \in5, \in4
eor.w \in7, \in7, \in4
tst.w \bb, #16
itttt ne
eorne.w \outr0, \outr0, \in4
eorne.w \outr1, \outr1, \in5
eorne.w \outr2, \outr2, \in6
eorne.w \outr3, \outr3, \in7
eor.w \in4, \in4, \in3
eor.w \in6, \in6, \in3
tst.w \bb, #32
itttt ne
eorne.w \outr0, \outr0, \in3
eorne.w \outr1, \outr1, \in4
eorne.w \outr2, \outr2, \in5
eorne.w \outr3, \outr3, \in6
eor.w \in3, \in3, \in2
eor.w \in5, \in5, \in2
tst.w \bb, #64
itttt ne
eorne.w \outr0, \outr0, \in2
eorne.w \outr1, \outr1, \in3
eorne.w \outr2, \outr2, \in4
eorne.w \outr3, \outr3, \in5
eor.w \in2, \in2, \in1
eor.w \in4, \in4, \in1
tst.w \bb, #128
itttt ne
eorne.w \outr0, \outr0, \in1
eorne.w \outr1, \outr1, \in2
eorne.w \outr2, \outr2, \in3
eorne.w \outr3, \outr3, \in4
vmov.w \outf0, \outr0
vmov.w \outf1, \outr1
vmov.w \outf2, \outr2
vmov.w \outf3, \outr3
tst.w \bb, #1
vmov.w \in1, \inf0
vmov.w \in2, \inf1
vmov.w \in3, \inf2
vmov.w \in4, \inf3
vmov.w \in5, \inf4
vmov.w \in6, \inf5
vmov.w \in7, \inf6
vmov.w \in0, \inf7
vmov.w \outr0, \outf4
vmov.w \outr1, \outf5
vmov.w \outr2, \outf6
vmov.w \outr3, \outf7
itttt ne
eorne.w \outr0, \outr0, \in5
eorne.w \outr1, \outr1, \in6
eorne.w \outr2, \outr2, \in7
eorne.w \outr3, \outr3, \in0
eor.w \in1, \in1, \in0
eor.w \in3, \in3, \in0
eor.w \in4, \in4, \in0
tst.w \bb, #2
itttt ne
eorne.w \outr0, \outr0, \in4
eorne.w \outr1, \outr1, \in5
eorne.w \outr2, \outr2, \in6
eorne.w \outr3, \outr3, \in7
eor.w \in0, \in0, \in7
eor.w \in2, \in2, \in7
eor.w \in3, \in3, \in7
tst.w \bb, #4
itttt ne
eorne.w \outr0, \outr0, \in3
eorne.w \outr1, \outr1, \in4
eorne.w \outr2, \outr2, \in5
eorne.w \outr3, \outr3, \in6
eor.w \in7, \in7, \in6
eor.w \in1, \in1, \in6
eor.w \in2, \in2, \in6
tst.w \bb, #8
itttt ne
eorne.w \outr0, \outr0, \in2
eorne.w \outr1, \outr1, \in3
eorne.w \outr2, \outr2, \in4
eorne.w \outr3, \outr3, \in5
eor.w \in6, \in6, \in5
eor.w \in0, \in0, \in5
eor.w \in1, \in1, \in5
tst.w \bb, #16
itttt ne
eorne.w \outr0, \outr0, \in1
eorne.w \outr1, \outr1, \in2
eorne.w \outr2, \outr2, \in3
eorne.w \outr3, \outr3, \in4
eor.w \in7, \in7, \in4
eor.w \in0, \in0, \in4
tst.w \bb, #32
itttt ne
eorne.w \outr0, \outr0, \in0
eorne.w \outr1, \outr1, \in1
eorne.w \outr2, \outr2, \in2
eorne.w \outr3, \outr3, \in3
eor.w \in6, \in6, \in3
eor.w \in7, \in7, \in3
tst.w \bb, #64
itttt ne
eorne.w \outr0, \outr0, \in7
eorne.w \outr1, \outr1, \in0
eorne.w \outr2, \outr2, \in1
eorne.w \outr3, \outr3, \in2
eor.w \in6, \in6, \in2
tst.w \bb, #128
itttt ne
eorne.w \outr0, \outr0, \in6
eorne.w \outr1, \outr1, \in7
eorne.w \outr2, \outr2, \in0
eorne.w \outr3, \outr3, \in1
vmov.w \outf4, \outr0
vmov.w \outf5, \outr1
vmov.w \outf6, \outr2
vmov.w \outf7, \outr3
.endm

