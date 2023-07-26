import assembunny
import os

type Puzzle* = enum Day12_Part1, Day12_Part2

proc day12*(mode: Puzzle) =

    var registers: ABM_Registers
    case mode:
        of Day12_Part1:
            registers = [0,0,0,0]
        of Day12_Part2:
            registers = [0,0,1,0]

    const runSample = false

    var ABM = newABM(os.getAppDir() & "\\..\\input\\day12" & (if runSample: "_sample.txt" else: ".txt"))
    ABM.setRegisters(registers)
    ABM.run()
    echo ABM.getRegisters()[0]
