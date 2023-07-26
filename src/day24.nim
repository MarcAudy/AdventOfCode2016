import lists
import os
import sets
import tables

type Point = tuple[
    x: int,
    y: int
]

type GridObj = enum
    Wall,
    Open,
    Zero,
    One,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven
type GridObjs = set[GridObj]

const GridObjChars = {'#':Wall,'.':Open,'0':Zero,'1':One,'2':Two,'3':Three,'4':Four,'5':Five,'6':Six,'7':Seven}.toTable

type State = tuple[
    steps: int,
    curPoint: Point,
    objState: GridObjs
]

type SeenState = tuple[
    curPoint: Point,
    objState: GridObjs
]

type Result = enum Continue, Finished
type Day24_Part* = enum Day24_Part1, Day24_Part2

proc day24*(part: Day24_Part) =

    const runSample = false

    let f = open(os.getAppDir() & "\\..\\input\\day24" & (if runSample: "_sample.txt" else: ".txt"))
    defer: f.close()
    var line : string

    var grid: seq[seq[GridObj]]
    var startPos: Point

    const targetObjState = if runSample: {One,Two,Three,Four} else: {One,Two,Three,Four,Five,Six,Seven}

    while f.read_line(line):
        grid.setLen(grid.len()+1)
        for c in line:
            grid[high(grid)].add(GridObjChars[c])
            if GridObjChars[c] == Zero:
                startPos = (high(grid[high(grid)]),high(grid)) 

    var stateStore: SinglyLinkedList[State]
    var seenStates: HashSet[SeenState]

    stateStore.add((0, startPos, {}))

    proc evaluateNextPoint(curState: State, nextPoint: Point): Result =
            let nextGridObj = grid[nextPoint.y][nextPoint.x]
            if nextGridObj != Wall:
                var nextState = curState
                inc nextState.steps
                nextState.curPoint = nextPoint
                if nextGridObj != Open:

                    if nextGridObj != Zero:
                        incl(nextState.objState, nextGridObj)

                    if part == Day24_Part1 or nextGridObj == Zero:
                        if nextState.objState == targetObjState:
                            echo nextState.steps
                            return Finished
                        
                if not seenStates.containsOrIncl((nextState.curPoint,nextState.objState)):
                    stateStore.add(nextState)

            return Continue

    while stateStore.head != nil:
        let curState = stateStore.head.value
        stateStore.head = stateStore.head.next
        if curState.curPoint.x > 0:
            if evaluateNextPoint(curState, (curState.curPoint.x-1, curState.curPoint.y)) == Finished:
                break
        if curState.curPoint.x < high(grid[0]):
            if evaluateNextPoint(curState, (curState.curPoint.x+1, curState.curPoint.y)) == Finished:
                break
        if curState.curPoint.y > 0:
            if evaluateNextPoint(curState, (curState.curPoint.x, curState.curPoint.y-1)) == Finished:
                break
        if curState.curPoint.y < high(grid):
            if evaluateNextPoint(curState, (curState.curPoint.x, curState.curPoint.y+1)) == Finished:
                break
