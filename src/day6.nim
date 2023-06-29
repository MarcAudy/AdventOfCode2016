import os
import std/tables

proc day6*() =

    let f = open(os.getAppDir() & "\\..\\input\\day6.txt")
    defer: f.close()
    var line : string

    var passcode = ""
    var counts: array[0..7, CountTable[char]]

    while f.read_line(line):

        for i in 0..<line.len():
            counts[i].inc(line[i])

    for i in 0..7:
        if counts[i].len() > 0:
            passcode &= counts[i].largest().key

    echo passcode
    
