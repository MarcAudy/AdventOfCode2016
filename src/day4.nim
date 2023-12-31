import os
import regex
import sequtils
import strutils
import std/algorithm
import std/tables

proc day4*() =

    let f = open(os.getAppDir() & "\\..\\input\\day4.txt")
    defer: f.close()
    var line : string

    var goodRoomSum = 0

    while f.read_line(line):

        var m: RegexMatch
        doAssert line.match(re"(.*)-(\d+)\[(.*)\]", m)

        let name = line[m.group(0)[0]]
        let sectorID = parseInt(line[m.group(1)[0]])
        let checkSum = line[m.group(2)[0]]

        var charMap = toCountTable(name)
        charMap.del('-')
        var sortedChars = toSeq(charMap.pairs).mapIt((ch: it[0], count: it[1]))
        sortedChars.sort(proc (a: tuple[ch:char,count:int],b: tuple[ch:char,count:int]): int =
                            if a.count == b.count: return int(a.ch) - int(b.ch)
                            else: return b.count - a.count)

        var goodRoom = true
        for i in 0..4:
            if sortedChars[i].ch != checkSum[i]:
                goodRoom = false
                break

        if goodRoom:
            goodRoomSum += sectorID

            var newLine = ""
            if goodRoom:
                for c in name:
                    if c == '-':
                        newLine &= ' '
                    else:
                        newLine &= char(((int(c) - int('a') + sectorID) %% 26) + int('a'))

                # This output all unscrambled sectors, going through them identified that
                # the desired room was "northpole object storage" which the final implementation
                # now outputs the sector ID of
                # echo $sectorID, ' ', newLine
                if newLine == "northpole object storage":
                    echo "DAY4 PART2: ", $sectorID

    echo "DAY4 PART1: ", $goodRoomSum
