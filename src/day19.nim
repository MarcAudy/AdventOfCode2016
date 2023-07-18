#const DAY19_PART1 = 1
const DAY19_PART2 = 1

# Samples
#const initialElfCount = 5

# Part 1
const initialElfCount = 3005290

proc day19*() =

    var elves: seq[bool]
    for i in 1..initialElfCount:
        elves.add(true)

    var remainingElves = initialElfCount

    proc getNextValidElf(curElf: int): int = 
        var nextElf = (curElf + 1) %% len(elves)
        while not elves[nextElf]:
            nextElf = (nextElf + 1) %% len(elves)
        return nextElf

    proc getElfToRemove(curElf: int): int =
        when declared(DAY19_PART1):
            return getNextValidElf(curElf)
        when declared(DAY19_PART2):
            var elfToRemove = curElf
            var nextElfCount = int(remainingElves / 2)
            while nextElfCount > 0:
                elfToRemove = getNextValidElf(elfToRemove)
                dec nextElfCount
            return elfToRemove

    var elfIndex = 0
    while remainingElves > 1:
        let elfToRemove = getElfToRemove(elfIndex)
        elves[elfToRemove] = false
        dec remainingElves
        elfIndex = getNextValidElf(elfIndex)

    echo elfIndex + 1