#import day1
#import day2
import day2_part2

#[import std/times
proc timeFunction(f: proc(), count: int = 1): float =
    let startTime = cpuTime()
    for i in 0 ..< count:
        f()
    let endTime = cpuTime()
    return endTime - startTime
]#

day2_part2()
