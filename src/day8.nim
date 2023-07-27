import os
import regex
import seqUtils
import strutils
import std/bitops

const GridHeight = 6
const GridWidth = 50

proc drawGrid(grid: array[GridHeight, uint64]) =
    for row in 0..<GridHeight:
        var gridLine = ""
        for col in 0..<GridWidth:
            gridLine &= (if (grid[row] and (1u64 shl col)) != 0: '#' else: ' ')
        echo gridLine
    echo ""

proc day8*() =

    let f = open(os.getAppDir() & "\\..\\input\\day8.txt")
    defer: f.close()
    var line: string

    var grid: array[GridHeight, uint64]

    while f.read_line(line):
        var m: RegexMatch
        if line.match(re"rect (\d+)x(\d+)", m):
            let rows = parseInt(m.groupFirstCapture(1,line))
            let cols = parseInt(m.groupFirstCapture(0,line))

            for x in 0..<cols:
                for y in 0..<rows:
                    grid[y].setBit(x)

        else:
            doAssert line.match(re"rotate (\w+ .)=(\d+) by (\d+)", m)

            if m.groupFirstCapture(0, line) == "row y":
                let row = parseInt(m.groupFirstCapture(1,line))          
                let by = parseInt(m.groupFirstCapture(2,line)) %% GridWidth
                let newC0 = GridWidth - by
                let newStartMask = grid[row].bitsliced(newC0..<GridWidth)
                grid[row].bitslice(0..<newC0)
                grid[row] = grid[row].rotateLeftBits(by)
                grid[row].setMask(newStartMask)
            else:
                doAssert m.groupFirstCapture(0, line) == "column x"
                let col = parseInt(m.groupFirstCapture(1,line))
                let by = (parseInt(m.groupFirstCapture(2,line)) %% GridHeight)
                var colBits: uint64
                for row in 0..<GridHeight:
                    if grid[row].testBit(col):
                        colBits.setBit(row)
                for row in 0..<GridHeight:
                    # Add GridHeight because mod of a negative number doesn't give us the desired value
                    if colBits.testBit((row-by+GridHeight)%%GridHeight):
                        grid[row].setBit(col)
                    else:
                        grid[row].clearBit(col)

    var enabledBits = 0
    grid.apply(proc (row: uint64) = enabledBits += row.countSetBits())

    echo "DAY8 PART1: ", $enabledBits
    echo "DAY8 PART2:"
    drawGrid(grid)