import os
import regex
import seqUtils
import strutils

proc day9*() =

    let f = open(os.getAppDir() & "\\..\\input\\day9.txt")
    defer: f.close()
    var line: string


    while f.read_line(line):

        var decompressedLength = 0
        var i = 0
        while i < line.len():
            if line[i] == '(':
                var m: RegexMatch
                doAssert line[i+1..^1].match(re"((\d+)x(\d+)\)).*", m)
                let segLength = parseInt(m.groupFirstCapture(1,line[i+1..^1]))
                let repCount = parseInt(m.groupFirstCapture(2,line[i+1..^1]))
                let markerLength = m.groupFirstCapture(0,line[i+1..^1]).len() + 1
                decompressedLength += segLength * repCount
                i += segLength + markerLength

            else:
                decompressedLength += 1
                i += 1

        echo $decompressedLength
