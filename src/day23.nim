import assembunny
import os

type Puzzle* = enum Day23_Part1, Day23_Part2

proc day23*(mode: Puzzle) =

    var registers: ABM_Registers
    case mode:
        of Day23_Part1:
            registers = [7,0,0,0]
        of Day23_Part2:
            registers = [12,0,0,0]

    const runSample = false

    var ABM = newABM(os.getAppDir() & "\\..\\input\\day23" & (if runSample: "_sample.txt" else: ".txt"))
    ABM.setRegisters(registers)
    ABM.run()
    echo ABM.getRegisters()[0]
