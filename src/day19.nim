# Samples
#const initialElfCount = 5

# Part 1
const initialElfCount = 3005290

proc day19*() =

    var firstElf = 1
    var elfStep = 1
    var elfCount = initialElfCount

    while elfCount > 1:
        elfStep *= 2
        if elfCount %% 2 == 1:
            firstElf += elfStep
        elfCount = int(elfCount / 2)

    echo firstElf