import os
import regex
import strutils

#const DAY12_PART1 = 1
const DAY12_PART2 = 1

type Commands = enum
    Copy,
    Inc,
    Dec,
    JNZ

type ArgumentType = enum None, Value, Register
type Argument = object
    case argType: ArgumentType
    of Value:
        val: int
    of Register:
        register: int
    else:
        discard

when declared(DAY12_PART1):
    var registers = [0,0,0,0]

when declared(DAY12_PART2):
    var registers = [0,0,1,0]

proc newArgument(arg: string): Argument =
    if arg[0] in {'a','b','c','d'}:
        return Argument(argType: Register, register: cast[int](arg[0])-cast[int]('a'))
    else:
        return Argument(argType: Value, val: parseInt(arg))

proc getValue(arg: Argument): int =
    case arg.argType:
    of Value:
        return arg.val
    of Register:
        return registers[arg.register]
    else:
        doAssert false

type Instruction = tuple[
    command: Commands,
    arg1: Argument,
    arg2: Argument
]

proc day12*() =

    let f = open(os.getAppDir() & "\\..\\input\\day12.txt")
    defer: f.close()
    var line : string

    var program: seq[Instruction]

    while f.read_line(line):

        var m: RegexMatch
        doAssert line.match(re"(\w+) (\w+)(?: (.*))?", m)

        case m.groupFirstCapture(0,line):
            of "cpy":
                program.add((Copy,newArgument(m.groupFirstCapture(1,line)),newArgument(m.groupFirstCapture(2,line))))
            of "inc":
                program.add((Inc,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
            of "dec":
                program.add((Dec,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
            of "jnz":
                program.add((JNZ,newArgument(m.groupFirstCapture(1,line)),newArgument(m.groupFirstCapture(2,line))))
            else:
                doAssert false
        
    var IP = 0
    while IP < program.len():
        case program[IP].command:
        of Copy:
            registers[program[IP].arg2.register] = program[IP].arg1.getValue()
            inc IP
        of Inc:
            inc registers[program[IP].arg1.register]
            inc IP
        of Dec:
            dec registers[program[IP].arg1.register]
            inc IP
        of JNZ:
            if program[IP].arg1.getValue() != 0:
                IP += program[IP].arg2.getValue()
            else:
                inc IP

    echo registers[0]
