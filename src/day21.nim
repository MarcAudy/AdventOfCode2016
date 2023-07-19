import algorithm
import os
import regex
import strutils

proc day21*() =
 
    # Sample
    #const fileName = "day21_sample.txt"
    #var passcode = "abcde"

    # Part 1
    const fileName = "day21.txt"
    var passcode = "abcdefgh"

    let f = open(os.getAppDir() & "\\..\\input\\" & fileName)
    defer: f.close()
    var line : string

    while f.read_line(line):
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
            if m.groupFirstCapture(0,line) == "left":
                passcode.rotateLeft(steps)
            else:
                passcode.rotateLeft(-steps)

        elif line.match(re"rotate based on position of letter (.)", m):
            let p = passcode.find(m.groupFirstCapture(0,line)[0])
            let steps = p + 1 + (if p >= 4: 1 else: 0)
            passcode.rotateLeft(-steps)

        elif line.match(re"reverse positions (\d+) through (\d+)", m):
            var p1 = parseInt(m.groupFirstCapture(0,line))
            var p2 = parseInt(m.groupFirstCapture(1,line))
            while p1 < p2:
                swap(passcode[p1],passcode[p2])
                inc p1
                dec p2

        elif line.match(re"move position (\d+) to position (\d+)", m):
            let p1 = parseInt(m.groupFirstCapture(0,line))
            let p2 = parseInt(m.groupFirstCapture(1,line))
            let ch = passcode[p1]
            passcode.delete(p1..p1)
            passcode.insert($ch, p2)

        else:
            echo line
            doAssert false

    echo passcode