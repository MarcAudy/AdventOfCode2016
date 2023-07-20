import os
import regex
import sequtils
import strutils
import tables

type Node = tuple[
    size: int,
    used: int
]

proc avail(n: Node): int =
    return n.size - n.used

type Point = tuple[
    x: int,
    y: int
]

proc day22*() =
 
    let f = open(os.getAppDir() & "\\..\\input\\day22.txt")
    defer: f.close()
    var line : string

    #toss first 2 uninteresting lines
    discard f.read_line(line)
    discard f.read_line(line)

    var nodes: Table[Point, Node]

    while f.read_line(line):
        var m: RegexMatch
        doAssert line.match(re"\/dev\/grid\/node-x(\d+)-y(\d+)\s*(\d+)T\s*(\d+)T\s*(\d+)T\s*(\d+)%", m)

        let p = (parseInt(m.groupFirstCapture(0,line)),parseInt(m.groupFirstCapture(1,line)))
        let size = parseInt(m.groupFirstCapture(2,line))
        let used = parseInt(m.groupFirstCapture(3,line))
       
        nodes[p] = (size,used)

    var valid = 0
    let nodeSeq = nodes.values.toSeq
    for i in 0..high(nodeSeq):
        for j in 0..high(nodeSeq):
            if i != j:
                if nodeSeq[i].used > 0 and nodeSeq[j].avail() >= nodeSeq[i].used:
                    inc valid

    echo valid
