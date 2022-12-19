#!/usr/bin/env python3

from re import I


bits = 8
poly = 0x1b

class Instr:
    def __init__(self, instr, dest=None, src1=None, src2=None):
        self.instr = instr
        self.dest = dest
        self.src1 = src1
        self.src2 = src2


    def __repr__(self) -> str:
        if self.dest == None:
            return self.instr
        elif self.src2 == None:
            return f"{self.instr} {self.dest}, {self.src1}"
        else:
            return f"{self.instr} {self.dest}, {self.src1}, {self.src2}"

ms = [(poly >> i) & 1 for i in range(bits)]

instructions = []

def cxor(xs, ys):
    assert len(xs) == len(ys)
    # groups of at most 4
    xs = [xs[i:i+4] for i in range(0, len(xs), 4)]
    ys = [ys[i:i+4] for i in range(0, len(ys), 4)]
    for xs, ys in zip(xs, ys):
        it = "t"*len(xs)
        # print(f"i{it} ne")
        instructions.append(Instr(f"i{it} ne"))
        for x, y in zip(xs, ys):
            instructions.append(Instr("eorne.w", f"\{x}", f"\{x}", f"\{y}"))

def double(ins):
    inhi = ins[-1]
    assert ms[0] == 1
    ins = [inhi] + ins[:-1]
    for j in range(1, bits):
        if ms[j]:
            instructions.append(Instr("eor.w", f"\{ins[j]}", f"\{ins[j]}", f"\{inhi}"))

    return ins


def vmov(outs, ins):
    assert len(outs) == len(ins)
    for i in range(len(outs)):
        instructions.append(Instr("vmov.w", f"\{outs[i]}", f"\{ins[i]}"))

def eliminate():
    global instructions
    def findFirstUseAsSource(instructions, source):
        for i in range(len(instructions)):
            instr = instructions[i]

            if instr.src1 == source or instr.src2 == source:
                return I
        return None

    newInstr = []


    for i in range(len(instructions)-1):
        instr = instructions[i]

        if instr.dest == None or instr.instr == "vmov.w" or findFirstUseAsSource(instructions[i+1:], instr.dest) != None:
            newInstr.append(instr)
        # else: 
        #     if findFirstUseAsSource(instructions[i+1:], instr.dest) == None:
        #         print(f"eliminate {i}: {instr}")

    newInstr.append(instructions[-1])

    d = len(instructions)-len(newInstr)
    # print(f"eliminated {d} of {len(instructions)}")

    instructions = newInstr
    if d > 0:
        eliminate()


def mul(outf, outr, ins, insf, b):
    c = ", ".join(outf+outr+ins+insf+[b])
    print(f".macro gf256mul_bitsliced {c}")

    assert len(outf) == bits
    assert len(outf) % len(outr)  == 0
    assert len(ins) == bits


    for r in range(len(outf)//len(outr)):
        instructions.clear()
        vmov(ins, insf)

        outfr = outf[r*len(outr):(r+1)*len(outr)]
        vmov(outr, outfr)

        insr = ins[r*len(outr):(r+1)*len(outr)]
        print(f"tst.w \{b}, #1")
        cxor(outr, insr)


        # 1-7
        for i in range(1,bits):
            ins = double(ins)
            instructions.append(Instr(f"tst.w \{b}, #{1<<i}"))
            insr = ins[r*len(outr):(r+1)*len(outr)]
            cxor(outr, insr)

        vmov(outfr, outr)
        eliminate()

        for instr in instructions:
            print(instr)
    print(".endm")

mul([f"outf{i}" for i in range(8)], [f"outr{i}" for i in range(4)], [f"in{i}" for i in range(8)], [f"inf{i}" for i in range(8)], "bb")
