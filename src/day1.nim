import os
import regex
import sets
import strutils

proc day1*() =

    let f = open(os.getAppDir() & "\\..\\input\\day1.txt")
    defer: f.close()
    var line : string
    while f.read_line(line):

        var facing = 0
        var P = (x: 0, y: 0)
        var checkVisited = true
        var visited = toHashSet([P])

        var m: RegexMatch
        doAssert line.match(re"(?:\s*(.\d*)(?:,|$))+", m)

        for bounds in m.group(0):

            if line[bounds][0] == 'L':
                facing = (facing - 1) %% 4
            else:
                facing = (facing + 1) %% 4

            let steps = parseInt(line[bounds][1..^1])
            for step in 0 ..< steps:
                case facing:
                    of 0:
                        P.y -= 1
                    of 1:
                        P.x += 1
                    of 2:
                        P.y += 1
                    of 3:
                        P.x -= 1
                    else:
                        doAssert(false)

                if (checkVisited and visited.containsOrIncl(P)):
                    echo "PART2: " & $(abs(P.x) + abs(P.y))
                    checkVisited = false
     

        echo "PART1: " & $(abs(P.x) + abs(P.y))