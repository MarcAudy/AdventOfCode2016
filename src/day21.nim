import algorithm
import os
import regex
import strutils
import tables

proc day21*() =
 
    const part1 = false

    # Sample
    #const fileName = if part1: "day21_sample.txt" else: "day21.txt"
    #var passcode = if part1: "abcde" else: "bgfacdeh"

    # Part 1
    const fileName = "day21.txt"
    var passcode = if part1: "abcdefgh" else: "fbgdceah"

    if not part1:
        # Part2 only works for the 8 digit case
        doAssert len(passcode) == 8
    const PART2_ROTATE_MAP = {0:1, 1:1, 2: -2, 3:2, 4: -1, 5:3, 6:0, 7:4}.toTable

    let f = open(os.getAppDir() & "\\..\\input\\" & fileName)
    defer: f.close()
    var line : string

    var lines: seq[string]
    while f.read_line(line):
        lines.add(line)

    var i = if part1: 0 else: high(lines)
    while i in 0..high(lines):
        line = lines[i]

        var m: RegexMatch
        
        if line.match(re"swap position (\d+) with position (\d+)", m):
            let p1 = parseInt(m.groupFirstCapture(0,line))
            let p2 = parseInt(m.groupFirstCapture(1,line))
            swap(passcode[p1], passcode[p2])

        elif line.match(re"swap letter (.) with letter (.)", m):
            let char1 = m.groupFirstCapture(0,line)[0]
            let char2 = m.groupFirstCapture(1,line)[0]
            let p1 = passcode.find(char1)
            let p2 = passcode.find(char2)
            passcode[p1] = char2
            passcode[p2] = char1

        elif line.match(re"rotate (left|right) (\d+) steps?", m):
            let steps = parseInt(m.groupFirstCapture(1,line))
            if m.groupFirstCapture(0,line) == (if part1: "left" else: "right"):
                passcode.rotateLeft(steps)
            else:
                passcode.rotateLeft(-steps)

        elif line.match(re"rotate based on position of letter (.)", m):
            let p = passcode.find(m.groupFirstCapture(0,line)[0])
            if part1:
                let steps = p + 1 + (if p >= 4: 1 else: 0)
                passcode.rotateLeft(-steps)
            else:
                let steps = PART2_ROTATE_MAP[p]
                passcode.rotateLeft(steps)

        elif line.match(re"reverse positions (\d+) through (\d+)", m):
            var p1 = parseInt(m.groupFirstCapture(0,line))
            var p2 = parseInt(m.groupFirstCapture(1,line))
            while p1 < p2:
                swap(passcode[p1],passcode[p2])
                inc p1
                dec p2

        elif line.match(re"move position (\d+) to position (\d+)", m):
            let p1 = parseInt(m.groupFirstCapture((if part1: 0 else: 1),line))
            let p2 = parseInt(m.groupFirstCapture((if part1: 1 else: 0),line))
            let ch = passcode[p1]
            passcode.delete(p1..p1)
            passcode.insert($ch, p2)

        else:
            echo line
            doAssert false

        if part1:
            inc i
        else:
            dec i

    echo passcode