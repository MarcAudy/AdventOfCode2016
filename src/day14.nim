import re
import std/md5
import strutils

#const DAY14_PART1 = 1
const DAY14_PART2 = 1

proc day14*() =

    #let salt = "abc"
    let salt = "zpqevtbw"

    when declared(DAY14_PART1):
        proc getHash(index: int): string =
            return getMD5(salt & $index)

    when declared(DAY14_PART2):
        var stretchedHashes: seq[string]
        proc getHash(index: int): string =
            if index >= stretchedHashes.len():
                for i in stretchedHashes.len()..index:
                    stretchedHashes.add(getMD5(salt & $i))
                    for n in 1..2016:
                        stretchedHashes[i] = getMD5(stretchedHashes[i])
            return stretchedHashes[index]
                
    var index = -1
    var foundKeys: int

    while foundKeys < 64:

        inc index

        let hash = getHash(index)
        let match = hash.find(re.re"(.)\1\1")
        if match != -1:
            let tripletChar = hash[match]
            let pentaChar = tripletChar&tripletChar&tripletChar&tripletChar&tripletChar
            block keycheck:
                for i in index+1..index+1000:
                    if getHash(i).contains(pentaChar):
                        inc foundKeys
                        echo "Found Key ", foundKeys, ": Index=", index, " i=", i, " hash=", hash
                        break keycheck

    echo index
