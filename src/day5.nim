import std/md5
import strutils

proc day5*() =

    # Sample
    #let doorID = "abc"

    # Puzzle input
    let doorID = "ojvtpuvg"

    var index = 0

    var found: set[char]

    var part1_passcode: string
    var part2_passcode = "________"

    while found.len() < 8:
        let hash = getMD5(doorID & $index)
        if hash.startsWith("00000"):

            if part1_passcode.len() < 8:
                part1_passcode &= hash[5]

            if hash[5] >= '0' and hash[5] < '8' and hash[5] notin found:
                found.incl(hash[5])
                part2_passcode[int(hash[5])-int('0')] = hash[6]
            
        index += 1

    echo "DAY5 PART1: " & part1_passcode
    echo "DAY5 PART2: " & part2_passcode
