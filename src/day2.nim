import os

proc day2*() =

    let f = open(os.getAppDir() & "\\..\\input\\day2.txt")
    defer: f.close()
    var line : string

    var curKey = 5
    var keyCode = ""

    while f.read_line(line):

        for c in line:
            case c:
                of 'U':
                    if curKey > 3:
                        curKey -= 3
                of 'D':
                    if curKey < 7:
                        curKey += 3
                of 'L':
                    if curKey %% 3 != 1:
                        curKey -= 1
                of 'R':
                    if curKey %% 3 != 0:
                        curKey += 1
                else:
                    doAssert false
        
        keyCode &= $curKey

    echo keyCode