import re
import std/md5
import strutils

type Disc = tuple[
    positions: int,
    initialPosition: int
]

proc day15*() =

    #Sample
    #const discs: array[2, Disc] = [(5,4),(2,1)]

    #Part 1
    const discs: array[6, Disc] = [(13,11),(5,0),(17,11),(3,0),(7,2),(19,17)]

    var time = 0
    while true:
        var failed = false
        for i in 0..<len(discs):
            if (discs[i].initialPosition + time + i + 1) %% discs[i].positions != 0:
                failed = true
                break
        if not failed:
            break
        inc time

    echo time
        

