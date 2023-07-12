import std/algorithm
import sequtils
import math

proc day16*() =

    # Sample
    #const targetSize = 20
    #const initialState = "10000"

    # Part 1
    #const targetSize = 272
    #const initialState = "11101000110010100"

    # Part 2
    const targetSize = 35651584
    const initialState = "11101000110010100"

    var state = initialState.toSeq().map(proc(ch: char): int = int(ch)-int('0'))

    while len(state) < targetSize:
        var bState = state.reversed()
        for ch in bState.mitems():
            ch = if ch == 1: 0 else: 1

        state.add(0)
        state &= bState

    state.setLen(targetSize)

    while true:
        var newState: seq[int]
        for i in 0..<int(len(state)/2):
            newState.add(if state[i*2] == state[(i*2)+1]: 1 else: 0)
        state = newState
        if state.len() %% 2 == 1:
            break

    echo state.foldl(a & chr(b+int('0')),"")