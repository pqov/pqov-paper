
.macro gf256_bitslice_4_tofpu outf0, outf1, outf2, outf3, outf4, outf5, outf6, outf7, in0, in1, in2, in3, tmp, tmp2
    // 16c
    and.w \tmp, \in0, #0x01010101
    and.w \tmp2, \in1, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in2,  #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in3, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#3
    vmov.w \outf0, \tmp

    // 16c
    and.w \tmp, \in1, #0x02020202
    and.w \tmp2, \in0, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in2, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in3, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#2
    vmov.w \outf1, \tmp

    // 16c
    and.w \tmp, \in2, #0x04040404
    and.w \tmp2, \in0, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in1, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in3, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#1
    vmov.w \outf2, \tmp

    // 16c
    and.w \tmp, \in3, #0x08080808
    and.w \tmp2, \in0, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in1, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in2, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#1
    vmov.w \outf3, \tmp

    // 16c
    mov.w \tmp, #0
    and.w \tmp2, \in0, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in1, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in2, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in3, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#1
    vmov.w \outf4, \tmp

    // 16c
    mov.w \tmp, #0
    and.w \tmp2, \in0, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in1, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in2, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in3, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#2
    vmov.w \outf5, \tmp

    // 16c
    mov.w \tmp, #0
    and.w \tmp2, \in0, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#6
    and.w \tmp2, \in1, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in2, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in3, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#3
    vmov.w \outf6, \tmp

    // 15c
    mov.w \tmp, #0
    and.w \tmp2, \in0, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#7
    and.w \tmp2, \in1, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#6
    and.w \tmp2, \in2, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in3, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#4
    vmov.w \outf7, \tmp
.endm

.macro gf256_unbitslice_4_tofpu outf0, outf1, outf2, outf3, in0, in1, in2, in3, in4, in5, in6, in7, tmp, tmp2
    // 16c
    and.w \tmp, \in0, #0x01010101
    and.w \tmp2, \in1, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in2,  #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in3, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in4, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in5, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#5
    and.w \tmp2, \in6, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#6
    and.w \tmp2, \in7, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#7
    vmov.w \outf0, \tmp

    // 16c
    and.w \tmp, \in1, #0x02020202
    and.w \tmp2, \in0, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in2, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in3, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in4, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in5, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in6, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#5
    and.w \tmp2, \in7, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#6
    vmov.w \outf1, \tmp

    // 16c
    and.w \tmp, \in2, #0x04040404
    and.w \tmp2, \in0, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in1, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in3, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in4, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in5, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in6, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in7, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#5
    vmov.w \outf2, \tmp

    // 16c
    and.w \tmp, \in3, #0x08080808
    and.w \tmp2, \in0, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in1, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in2, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in4, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in5, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in6, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in7, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#4
    vmov.w \outf3, \tmp
.endm

.macro gf256_bitslice_tofpu outf0, outf1, outf2, outf3, outf4, outf5, outf6, outf7, in0, in1, in2, in3, in4, in5, in6, in7, tmp, tmp2
    // 16c
    and.w \tmp, \in0, #0x01010101
    and.w \tmp2, \in1, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in2,  #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in3, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in4, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in5, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#5
    and.w \tmp2, \in6, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#6
    and.w \tmp2, \in7, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#7
    vmov.w \outf0, \tmp

    // 16c
    and.w \tmp, \in1, #0x02020202
    and.w \tmp2, \in0, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in2, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in3, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in4, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in5, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in6, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#5
    and.w \tmp2, \in7, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#6
    vmov.w \outf1, \tmp

    // 16c
    and.w \tmp, \in2, #0x04040404
    and.w \tmp2, \in0, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in1, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in3, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in4, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in5, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in6, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in7, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#5
    vmov.w \outf2, \tmp

    // 16c
    and.w \tmp, \in3, #0x08080808
    and.w \tmp2, \in0, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in1, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in2, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in4, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in5, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in6, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in7, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#4
    vmov.w \outf3, \tmp

    // 16c
    and.w \tmp, \in4, #0x10101010
    and.w \tmp2, \in0, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in1, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in2, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in3, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in5, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in6, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in7, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsl#3
    vmov.w \outf4, \tmp

    // 16c
    and.w \tmp, \in5, #0x20202020
    and.w \tmp2, \in0, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in1, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in2, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in3, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in4, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in6, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in7, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsl#2
    vmov.w \outf5, \tmp

    // 16c
    and.w \tmp, \in6, #0x40404040
    and.w \tmp2, \in0, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#6
    and.w \tmp2, \in1, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in2, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in3, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in4, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in5, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in7, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsl#1
    vmov.w \outf6, \tmp

    // 15c
    and.w \tmp, \in7, #0x80808080
    and.w \tmp2, \in0, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#7
    and.w \tmp2, \in1, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#6
    and.w \tmp2, \in2, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in3, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in4, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in5, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in6, #0x80808080
    orr.w \tmp, \tmp, \tmp2, lsr#1
    vmov.w \outf7, \tmp
.endm


//134c (of which 14 vmov)
.macro gf256_bitslice in0, in1, in2, in3, in4, in5, in6, in7, tmp, tmp2, tmpf0, tmpf1, tmpf2, tmpf3, tmpf4, tmpf5, tmpf6
    // 16c
    and.w \tmp, \in0, #0x01010101
    and.w \tmp2, \in1, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in2,  #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in3, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in4, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in5, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#5
    and.w \tmp2, \in6, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#6
    and.w \tmp2, \in7, #0x01010101
    orr.w \tmp, \tmp, \tmp2, lsl#7
    vmov.w \tmpf0, \tmp

    // 16c
    and.w \tmp, \in1, #0x02020202
    and.w \tmp2, \in0, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in2, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in3, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in4, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in5, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in6, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#5
    and.w \tmp2, \in7, #0x02020202
    orr.w \tmp, \tmp, \tmp2, lsl#6
    vmov.w \tmpf1, \tmp

    // 16c
    and.w \tmp, \in2, #0x04040404
    and.w \tmp2, \in0, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in1, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in3, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in4, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in5, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in6, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#4
    and.w \tmp2, \in7, #0x04040404
    orr.w \tmp, \tmp, \tmp2, lsl#5
    vmov.w \tmpf2, \tmp

    // 16c
    and.w \tmp, \in3, #0x08080808
    and.w \tmp2, \in0, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in1, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in2, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in4, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in5, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in6, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#3
    and.w \tmp2, \in7, #0x08080808
    orr.w \tmp, \tmp, \tmp2, lsl#4
    vmov.w \tmpf3, \tmp

    // 16c
    and.w \tmp, \in4, #0x10101010
    and.w \tmp2, \in0, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in1, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in2, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in3, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in5, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in6, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsl#2
    and.w \tmp2, \in7, #0x10101010
    orr.w \tmp, \tmp, \tmp2, lsl#3
    vmov.w \tmpf4, \tmp

    // 16c
    and.w \tmp, \in5, #0x20202020
    and.w \tmp2, \in0, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in1, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in2, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in3, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in4, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in6, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsl#1
    and.w \tmp2, \in7, #0x20202020
    orr.w \tmp, \tmp, \tmp2, lsl#2
    vmov.w \tmpf5, \tmp

    // 16c
    and.w \tmp, \in6, #0x40404040
    and.w \tmp2, \in0, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#6
    and.w \tmp2, \in1, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#5
    and.w \tmp2, \in2, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#4
    and.w \tmp2, \in3, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#3
    and.w \tmp2, \in4, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#2
    and.w \tmp2, \in5, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsr#1
    and.w \tmp2, \in7, #0x40404040
    orr.w \tmp, \tmp, \tmp2, lsl#1
    vmov.w \tmpf6, \tmp

    // 15c
    and.w \in7, \in7, #0x80808080
    and.w \tmp2, \in0, #0x80808080
    orr.w \in7, \in7, \tmp2, lsr#7
    and.w \tmp2, \in1, #0x80808080
    orr.w \in7, \in7, \tmp2, lsr#6
    and.w \tmp2, \in2, #0x80808080
    orr.w \in7, \in7, \tmp2, lsr#5
    and.w \tmp2, \in3, #0x80808080
    orr.w \in7, \in7, \tmp2, lsr#4
    and.w \tmp2, \in4, #0x80808080
    orr.w \in7, \in7, \tmp2, lsr#3
    and.w \tmp2, \in5, #0x80808080
    orr.w \in7, \in7, \tmp2, lsr#2
    and.w \tmp2, \in6, #0x80808080
    orr.w \in7, \in7, \tmp2, lsr#1
    // 7c
    vmov.w \in0, \tmpf0
    vmov.w \in1, \tmpf1
    vmov.w \in2, \tmpf2
    vmov.w \in3, \tmpf3
    vmov.w \in4, \tmpf4
    vmov.w \in5, \tmpf5
    vmov.w \in6, \tmpf6
.endm
