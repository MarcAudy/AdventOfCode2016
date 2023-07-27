import os
import regex
import strutils

proc day3*() =

    let f = open(os.getAppDir() & "\\..\\input\\day3.txt")
    defer: f.close()
    var line : array[3, string]

    var part1_possible = 0
    var part2_possible = 0

    proc isPossible(s1: int, s2: int, s3: int): bool =
        return s1 + s2 > s3 and
               s1 + s3 > s2 and
               s2 + s3 > s1

    while f.read_line(line[0]):

        doAssert f.read_line(line[1])
        doAssert f.read_line(line[2])

        var m: array[3, RegexMatch]
        for i in 0..2:
            doAssert line[i].match(re" *(\d+) +(\d+) +(\d+)", m[i])

        for i in 0..2:
            if isPossible(parseInt(line[i][m[i].group(0)[0]]),
                          parseInt(line[i][m[i].group(1)[0]]),
                          parseInt(line[i][m[i].group(2)[0]])):
                inc part1_possible

            if isPossible(parseInt(line[0][m[0].group(i)[0]]),
                          parseInt(line[1][m[1].group(i)[0]]),
                          parseInt(line[2][m[2].group(i)[0]])):
                inc part2_possible

    echo "DAY3 PART1: ", part1_possible
    echo "DAY3 PART2: ", part2_possible