import os
import regex
import strutils

proc day3*() =

    let f = open(os.getAppDir() & "\\..\\input\\day3.txt")
    defer: f.close()
    var line : string

    var possible = 0

    while f.read_line(line):

        var m: RegexMatch
        doAssert line.match(re" *(\d+) +(\d+) +(\d+)", m)

        let s1 = parseInt(line[m.group(0)[0]])
        let s2 = parseInt(line[m.group(1)[0]])
        let s3 = parseInt(line[m.group(2)[0]])

        if s1 + s2 > s3 and
           s1 + s3 > s2 and
           s2 + s3 > s1:
            possible += 1

    echo $possible