import os
import re
import regex

proc hasABBA(segment: string): bool =
    return segment.contains(re.re"(.)(?!\1)(.)\2\1")

proc supportsTLS(line: string): bool =
    var m: RegexMatch
    doAssert line.match(re"([^\[]+)(?:\[([^\]]+)\]([^\[]+))+", m)

    for bounds in m.group(1):
        if hasABBA(line[bounds]):
            return false

    if hasABBA(line[m.group(0)[0]]):
        return true

    for bounds in m.group(2):
        if hasABBA(line[bounds]):
            return true

    return false

proc day7*() =

    let f = open(os.getAppDir() & "\\..\\input\\day7.txt")
    defer: f.close()
    var line : string

    var supports = 0

    while f.read_line(line):
        if supportsTLS(line):
            supports += 1

    echo $supports
