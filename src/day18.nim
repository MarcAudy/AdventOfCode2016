import sequtils

# Samples
#const firstRow = ".^^.^.^^^^"
#const rowCount = 10

# Part 1
const firstRow = "^^.^..^.....^..^..^^...^^.^....^^^.^.^^....^.^^^...^^^^.^^^^.^..^^^^.^^.^.^.^.^.^^...^^..^^^..^.^^^^"
const rowCount = 40

const rowWidth = len(firstRow)

proc day18*() =

    var grid: array[rowCount, array[rowWidth, bool]]

    for i in 0..<rowWidth:
        grid[0][i] = firstRow[i] == '^'

    for row in 1..<rowCount:
        for i in 0..<rowWidth:
            let lTrap = i > 0 and grid[row-1][i-1]
            let cTrap = grid[row-1][i]
            let rTrap = i < rowWidth-1 and grid[row-1][i+1]

            grid[row][i] = ((lTrap and not cTrap and not rTrap) or
                            (rTrap and not cTrap and not lTrap) or
                            (lTrap and cTrap and not rTrap) or
                            (rTrap and cTrap and not lTrap))

    echo foldl(grid, a + count(b,false), 0)
                