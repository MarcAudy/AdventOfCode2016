import lists

#const DAY19_PART1 = 1
const DAY19_PART2 = 1

# Samples
#const initialElfCount = 5

# Part 1
const initialElfCount = 3005290

proc day19*() =
 
    when declared(DAY19_PART1):
        var firstElf = 1
        var elfStep = 1
        var elfCount = initialElfCount
        while elfCount > 1:
            elfStep *= 2
            if elfCount %% 2 == 1:
                firstElf += elfStep
            elfCount = int(elfCount / 2)
        echo firstElf

    when declared(DAY19_PART2):
        var elfToRemove: DoublyLinkedNode[int]
        var elves: DoublyLinkedRing[int]
        for i in 1..initialElfCount:
            elves.add(i)
            if i == int(initialElfCount / 2) + 1:
                elfToRemove = elves.head.prev

        var remainingElves = initialElfCount

        var elf = elves.head
        while elf.next != elf:
            let nextElfToRemove = elfToRemove.next
            elves.remove(elfToRemove)
            elf = elf.next

            elfToRemove = nextElfToRemove
            if remainingElves %% 2 == 1:
                elfToRemove = elfToRemove.next
            dec remainingElves

        echo elf.value