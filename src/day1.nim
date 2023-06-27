import os
import regex
import strutils

proc day1*() =

    let f = open(os.getAppDir() & "\\..\\input\\day1.txt")
    defer: f.close()
    var line : string
    while f.read_line(line):

        var facing = 0
        var x = 0
        var y = 0

        var m: RegexMatch
        doAssert line.match(re"(?:\s*(.\d*)(?:,|$))+", m)

        for i in 0 ..< m.groupsCount:
            for bounds in m.group(i):

                if line[bounds][0] == 'L':
                    facing = (facing - 1) %% 4
                else:
                    facing = (facing + 1) %% 4

                case facing:
                    of 0:
                        y -= parseInt(line[bounds][1..^1])
                    of 1:
                        x += parseInt(line[bounds][1..^1])
                    of 2:
                        y += parseInt(line[bounds][1..^1])
                    of 3:
                        x -= parseInt(line[bounds][1..^1])
                    else:
                        doAssert(false)

            echo "PART1: " & $(abs(x) + abs(y))