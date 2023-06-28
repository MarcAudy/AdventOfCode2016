import os
import regex
import strutils

proc day3_part2*() =

    let f = open(os.getAppDir() & "\\..\\input\\day3.txt")
    defer: f.close()
    var line1 : string

    var possible = 0

    while f.read_line(line1):

        var line2, line3: string
        doAssert f.read_line(line2)
        doAssert f.read_line(line3)

        var m1, m2, m3: RegexMatch
        doAssert line1.match(re" *(\d+) +(\d+) +(\d+)", m1)
        doAssert line2.match(re" *(\d+) +(\d+) +(\d+)", m2)
        doAssert line3.match(re" *(\d+) +(\d+) +(\d+)", m3)

        for col in 0..2:
            let s1 = parseInt(line1[m1.group(col)[0]])
            let s2 = parseInt(line2[m2.group(col)[0]])
            let s3 = parseInt(line3[m3.group(col)[0]])

            if s1 + s2 > s3 and
               s1 + s3 > s2 and
               s2 + s3 > s1:
                possible += 1

    echo $possible