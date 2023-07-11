import re
import std/md5
import strutils

proc day14*() =

    #let salt = "abc"
    let salt = "zpqevtbw"
    var index = -1
    var keys: seq[int]

    while keys.len() < 64:

        inc index

        let hash = getMD5(salt & $index)

        let match = hash.find(re.re"(.)\1\1")
        if match != -1:
            let tripletChar = hash[match]
            let pentaChar = tripletChar&tripletChar&tripletChar&tripletChar&tripletChar
            block keycheck:
                for i in index+1..index+1000:
                    if getMD5(salt & $i).contains(pentaChar):
                        keys.add(index)
                        echo "Found Key ", keys.len(), ": Index=", index, " i=", i, " hash=", hash
                        break keycheck

    echo index
