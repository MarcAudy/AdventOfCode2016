import sequtils

# Samples
#const firstRow = ".^^.^.^^^^"
#const rowCount = 10

# Part 1
#const firstRow = "^^.^..^.....^..^..^^...^^.^....^^^.^.^^....^.^^^...^^^^.^^^^.^..^^^^.^^.^.^.^.^.^^...^^..^^^..^.^^^^"
#const rowCount = 40

# Part 2
const firstRow = "^^.^..^.....^..^..^^...^^.^....^^^.^.^^....^.^^^...^^^^.^^^^.^..^^^^.^^.^.^.^.^.^^...^^..^^^..^.^^^^"
const rowCount = 400000

const rowWidth = len(firstRow)

proc day18*() =

    var curRow: array[rowWidth, bool]

    for i in 0..<rowWidth:
        curRow[i] = firstRow[i] == '^'

    var safeCount = count(curRow,false)

    var row = 1
    while row < rowCount:
        var nextRow: array[rowWidth, bool]
        for i in 0..<rowWidth:
            let lTrap = i > 0 and curRow[i-1]
            let cTrap = curRow[i]
            let rTrap = i < rowWidth-1 and curRow[i+1]

            nextRow[i] = ((lTrap and not cTrap and not rTrap) or
                          (rTrap and not cTrap and not lTrap) or
                          (lTrap and cTrap and not rTrap) or
                          (rTrap and cTrap and not lTrap))

            if not nextRow[i]:
                inc safeCount

        inc row
        curRow = nextRow

    echo safeCount
                