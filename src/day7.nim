import os
import re
import regex
import sequtils
import strutils

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

proc findABA(line: string, bounds: seq[Slice[int]], substr: string): bool = 
    for bound in bounds:
        if line[bound].contains(substr):
            return true

    return false

proc supportsSSL(line: string): bool =
    var m: RegexMatch
    doAssert line.match(re"([^\[]+)(?:\[([^\]]+)\]([^\[]+))+", m)

    let supernets = concat(m.group(0),m.group(2))

    for bounds in supernets:
        let segment = line[bounds]
        for i in 0..segment.len()-3:
            if segment[i] == segment[i+2] and segment[i] != segment[i+1]:
                if findABA(line, m.group(1), segment[i+1]&segment[i]&segment[i+1]):
                    return true

    return false

proc day7*() =

    let f = open(os.getAppDir() & "\\..\\input\\day7.txt")
    defer: f.close()
    var line : string

    var supportsTLS = 0
    var supportsSSL = 0

    while f.read_line(line):
        if supportsTLS(line):
            supportsTLS += 1
        if supportsSSL(line):
            supportsSSL += 1

    echo "DAY7 PART1: ", $supportsTLS
    echo "DAY7 PART2: ", $supportsSSL
