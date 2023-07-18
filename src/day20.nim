import algorithm
import os
import regex
import strutils

type Range = tuple[
    min: int,
    max: int
]

proc compareRanges(r1: Range, r2: Range): int =
    return cmp(r1.min, r2.min)

proc day20*() =
 
    let f = open(os.getAppDir() & "\\..\\input\\day20.txt")
    defer: f.close()
    var line : string

    var ranges: seq[Range]

    while f.read_line(line):
        var m: RegexMatch
        doAssert line.match(re"(\d+)-(\d+)", m)
        let nextRange: Range = (parseInt(m.groupFirstCapture(0,line)), parseInt(m.groupFirstCapture(1,line)))
        ranges.insert(nextRange, ranges.lowerBound(nextRange, compareRanges))

    var validIP = 0
    var validCount = 0
    for r in ranges:
        if validIP < r.min:
            if validCount == 0:
                echo "PART1: ", validIP

            validCount += r.min - validIP

        if validIP <= r.max:
            validIP = r.max + 1

    echo "PART2: ", validCount
