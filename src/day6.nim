import os
import std/tables

proc day6*() =

    let f = open(os.getAppDir() & "\\..\\input\\day6.txt")
    defer: f.close()
    var line : string

    var part1_passcode = ""
    var part2_passcode = ""
    var counts: array[0..7, CountTable[char]]

    while f.read_line(line):

        for i in 0..<line.len():
            counts[i].inc(line[i])

    for i in 0..7:
        if counts[i].len() > 0:
            part1_passcode &= counts[i].largest().key
            part2_passcode &= counts[i].smallest().key

    echo "PART1: ", part1_passcode
    echo "PART2: ", part2_passcode
    
