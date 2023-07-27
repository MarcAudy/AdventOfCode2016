import assembunny
import os

type Day23_Part = enum Day23_Part1, Day23_Part2

proc day23_internal(day23_part: Day23_Part): int =

    var registers: ABM_Registers
    case day23_part:
        of Day23_Part1:
            registers = [7,0,0,0]
        of Day23_Part2:
            registers = [12,0,0,0]

    const runSample = false

    var ABM = newABM(os.getAppDir() & "\\..\\input\\day23" & (if runSample: "_sample.txt" else: ".txt"))
    ABM.run(registers)
    return ABM.getRegisters()[0]

proc day23*() =
    echo "DAY23 PART1: ", day23_internal(Day23_Part1)
    echo "DAY23 PART2: ", day23_internal(Day23_Part2)
