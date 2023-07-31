import os
import regex
import strutils

proc day9*() =

    let f = open(os.getAppDir() & "\\..\\input\\day9.txt")
    defer: f.close()
    var line: string

    proc countSegment(segment: string): array[2, int] =
        var decompressedLength: array[2, int] = [0,0]
        var i = 0
        while i < segment.len():
            if segment[i] == '(':
                var m: RegexMatch
                doAssert segment[i+1..^1].match(re"((\d+)x(\d+)\)).*", m)
                let segLength = parseInt(m.groupFirstCapture(1,segment[i+1..^1]))
                let repCount = parseInt(m.groupFirstCapture(2,segment[i+1..^1]))
                let markerLength = m.groupFirstCapture(0,segment[i+1..^1]).len() + 1
                decompressedLength[0] += segLength * repCount
                decompressedLength[1] += repCount * countSegment(segment[i+markerLength..<i+markerLength+segLength])[1]
                i += segLength + markerLength

            else:
                inc decompressedLength[0]
                inc decompressedLength[1]
                inc i
        
        return decompressedLength

    while f.read_line(line):
        let result = countSegment(line)
        echo "DAY9 PART1: ", result[0]
        echo "DAY9 PART2: ", result[1]
