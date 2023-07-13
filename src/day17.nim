import lists
import std/md5
import tables

type Point = tuple[
    x: int,
    y: int
]

type State = tuple[
    p: Point,
    path: string
]

# Samples
#const passcode = "ihgpwlah"
#const passcode = "kglvqrro"
#const passcode = "ulqzkmiv"

# Part 1
const passcode = "bwnlcvfs"

const openChars = {'b','c','d','e','f'}

proc checkDoors(state: State): Table[char, tuple[open: bool, nextPoint: Point]] =
    let hash = getMD5(passcode & state.path)
    return {
        'U': (state.p.y > 0 and hash[0] in openChars, (state.p.x,state.p.y-1)),
        'D': (state.p.y < 3 and hash[1] in openChars, (state.p.x,state.p.y+1)),
        'L': (state.p.x > 0 and hash[2] in openChars, (state.p.x-1,state.p.y)),
        'R': (state.p.x < 3 and hash[3] in openChars, (state.p.x+1,state.p.y))
    }.toTable


proc day17*() =

    var statesToConsider: SinglyLinkedList[State]
    statesToConsider.add(((0,0), ""))

    var longestPath = 0

    while statesToConsider.head != nil:
        let curState = statesToConsider.head.value
        statesToConsider.remove(statesToConsider.head)

        let doorStates = checkDoors(curState)

        for door, doorState in doorStates.pairs():
            if doorState.open:
                if doorState.nextPoint == (3,3):
                    if longestPath == 0:
                        echo "PART1: ", curState.path & door
                    longestPath = len(curState.path) + 1
                else:
                    statesToConsider.add((doorState.nextPoint,curState.path & door))

    echo "PART2: ", longestPath