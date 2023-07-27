import assembunny
import os

type Day12_Part = enum Day12_Part1, Day12_Part2

proc day12_internal(day12_part: Day12_Part): int =

    var registers: ABM_Registers
    case day12_part:
        of Day12_Part1:
            registers = [0,0,0,0]
        of Day12_Part2:
            registers = [0,0,1,0]

    const runSample = false

    var ABM = newABM(os.getAppDir() & "\\..\\input\\day12" & (if runSample: "_sample.txt" else: ".txt"))
    ABM.run(registers)
    return ABM.getRegisters()[0]

proc day12*() =
    echo "DAY12 PART1: ", day12_internal(Day12_Part1)
    echo "DAY12 PART2: ", day12_internal(Day12_Part2)