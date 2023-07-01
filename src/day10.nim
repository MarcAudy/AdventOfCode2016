import os
import regex
import tables
import strutils
import system

proc day10*() =

    let f = open(os.getAppDir() & "\\..\\input\\day10.txt")
    defer: f.close()
    var line: string

    type BotInstruction = tuple[giveLowToOutput: bool, giveHighToOutput: bool, giveToLow: int, giveToHigh: int]

    var bots: Table[int, seq[int]]
    var outputs: Table[int, int]
    var instructions: Table[int, BotInstruction]

    var botsWithTwo: seq[int]
    while f.read_line(line):

        var m: RegexMatch
        doAssert line.match(re"(\w+) (\d+) (?:goes to|gives low to) (\w+) (\d+)(?: and high to (\w+) (\d+))?", m)

        if m.groupFirstCapture(0, line) == "value":
            doAssert m.groupFirstCapture(2, line) == "bot"
            let value = parseInt(m.groupFirstCapture(1, line))
            let bot = parseInt(m.groupFirstCapture(3, line))
            bots.mgetOrPut(bot, @[]).add(value)
            if bots[bot].len() == 2:
                botsWithTwo.add(bot)
        else:
            doAssert m.groupFirstCapture(0, line) == "bot"
            let bot = parseInt(m.groupFirstCapture(1, line))
            doAssert bot notin instructions
            let giveLowToOutput = m.groupFirstCapture(2, line) == "output"
            let giveHighToOutput = m.groupFirstCapture(4, line) == "output"
            let giveToLow = parseInt(m.groupFirstCapture(3, line))
            let giveToHigh = parseInt(m.groupFirstCapture(5, line))
            instructions[bot] = (giveLowToOutput, giveHighToOutput, giveToLow, giveToHigh)

    while botsWithTwo.len() > 0:

        let nextBot = botsWithTwo.pop()
        let high = bots[nextBot].max()
        let low = bots[nextBot].min()

        if high == 61 and low == 17:
            echo "PART1: ", nextBot

        let inst = instructions[nextBot]

        if inst.giveLowToOutput:
            doAssert inst.giveToLow notin outputs
            outputs[inst.giveToLow] = low
        else:
            bots.mgetOrPut(inst.giveToLow, @[]).add(low)
            if bots[inst.giveToLow].len() == 2:
                botsWithTwo.add(inst.giveToLow)

        if inst.giveHighToOutput:
            doAssert inst.giveToHigh notin outputs
            outputs[inst.giveToHigh] = low
        else:
            bots.mgetOrPut(inst.giveToHigh, @[]).add(high)
            if bots[inst.giveToHigh].len() == 2:
                botsWithTwo.add(inst.giveToHigh)

        bots.del(nextBot)

    echo "PART2: ", $(outputs[0]*outputs[1]*outputs[2])
            
