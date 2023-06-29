import std/md5
import strutils

proc day5_part2*() =

    #let doorID = "abc"
    let doorID = "ojvtpuvg"
    var index = 0
    var found: set[char]
    var passcode = "________"

    while found.len() < 8:
        let hash = getMD5(doorID & $index)
        if hash.startsWith("00000"):
            if hash[5] >= '0' and hash[5] < '8' and hash[5] notin found:
                found.incl(hash[5])
                passcode[int(hash[5])-int('0')] = hash[6]
                echo passcode, ' ', $index
            
        index += 1

    echo passcode
