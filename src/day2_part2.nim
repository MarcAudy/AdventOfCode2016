import os

type Grid[W, H: static[int]] =
    array[1..W, array[1..H, char]]

proc walkGrid[W, H](grid: Grid[W, H], start: tuple[x: int, y: int], prefix: string) =

    let f = open(os.getAppDir() & "\\..\\input\\day2.txt")
    defer: f.close()
    var line : string

    var loc = start
    var keyCode = prefix

    while f.read_line(line):

        for c in line:
            case c:
                of 'U':
                    if loc.y > 1 and grid[loc.y-1][loc.x] != ' ':
                        loc.y -= 1
                of 'D':
                    if loc.y < H and grid[loc.y+1][loc.x] != ' ':
                        loc.y += 1
                of 'L':
                    if loc.x > 1 and grid[loc.y][loc.x-1] != ' ':
                        loc.x -= 1
                of 'R':
                    if loc.x < W and grid[loc.y][loc.x+1] != ' ':
                        loc.x += 1
                else:
                    doAssert false
        
        keyCode &= grid[loc.y][loc.x]

    echo keyCode

proc day2_part2*() =

    let part1_grid: Grid[3,3] = [['1','2','3'],
                                 ['4','5','6'],
                                 ['7','8','9']]

    let part2_grid: Grid[5,5] = [[' ',' ','1',' ',' '],
                                 [' ','2','3','4',' '],
                                 ['5','6','7','8','9'],
                                 [' ','A','B','C',' '],
                                 [' ',' ','D',' ',' ']]

    let part1_start = (x: 2, y: 2)
    let part2_start = (x: 1, y: 3)

    walkGrid(part1_grid, part1_start, "PART1: ")
    walkGrid(part2_grid, part2_start, "PART2: ")