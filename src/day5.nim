import std/md5
import strutils

proc day5*() =

    #let doorID = "abc"
    let doorID = "ojvtpuvg"
    var index = 0

    while passcode.len() < 8:
        let hash = getMD5(doorID & $index)
        if hash.startsWith("00000"):
            passcode &= hash[5]
        index += 1

    echo passcode
