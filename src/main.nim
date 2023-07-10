import day11

#import nimprof 
#[
import std/times
proc timeFunction(f: proc(), count: int = 1): float =
    let startTime = cpuTime()
    for i in 0 ..< count:
        f()
    let endTime = cpuTime()
    return endTime - startTime

echo $timeFunction(day11.day11)
]#

day11()
