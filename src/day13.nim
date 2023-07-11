import algorithm
import bitops
import sequtils

#const DAY13_SAMPLE = 1

type Grid =
    seq[seq[int]]

type Point = tuple[
    x: int,
    y: int
]

when declared(DAY13_SAMPLE):
    const targetPoint: Point = (7,4)
    const magicNumber = 10
else:
    const targetPoint: Point = (31,39)
    const magicNumber = 1350

proc isWall(p: Point): bool =
    let val = p.x*p.x + 3*p.x + 2*p.x*p.y + p.y + p.y*p.y + magicNumber
    return (countSetBits(val) %% 2) == 1

proc scorePoint(p: Point): int =
    return abs(targetPoint.x - p.x) + abs(targetPoint.y - p.y)

proc comparePoints(p1: Point, p2: Point): int =
    return cmp(scorePoint(p2), scorePoint(p1))

proc setStepCount(grid: var Grid, p: Point, steps: int) =
    if p.x >= grid.len():
        grid.setLen(p.x+1)
    if p.y >= grid[p.x].len():
        grid[p.x].setLen(p.y+1)

    grid[p.x][p.y] = steps

proc getStepCount(grid: Grid, p: Point): int =
    if p.x < grid.len():
        if p.y < grid[p.x].len():
            return grid[p.x][p.y]
    return 0

proc day13*() =

    var grid: Grid
    var pointsToConsider: seq[Point] = @[(1,1)]
    var foundDistance = 0

    grid.setStepCount((1,1), 0)

    while pointsToConsider.len() > 0:
        let curPoint = pointsToConsider.pop()
        let curSteps = grid[curPoint.x][curPoint.y]
        let nextSteps = curSteps + 1

        if foundDistance > 0 and nextSteps >= foundDistance:
            continue

        proc considerNextPoint(nextPoint: Point) =
            if nextPoint == targetPoint and (foundDistance == 0 or nextSteps < foundDistance):
                foundDistance = nextSteps
            elif not nextPoint.isWall():
                let nextPointSteps = grid.getStepCount(nextPoint)
                if nextPointSteps == 0 or nextPointSteps > nextSteps:
                    grid.setStepCount(nextPoint, nextSteps)
                    pointsToConsider.insert(nextPoint, pointsToConsider.lowerBound(nextPoint, comparePoints))

        if curPoint.x > 0:
            considerNextPoint((curPoint.x - 1, curPoint.y))
        if curPoint.y > 0:
            considerNextPoint((curPoint.x, curPoint.y - 1))
        considerNextPoint((curPoint.x + 1, curPoint.y))
        considerNextPoint((curPoint.x, curPoint.y + 1))

    echo "PART1: ", foundDistance
    echo "PART2: ", grid.foldl(a + b.countIt(it in 1..50), 0)
