import os
import regex
import strutils
import tables

type Commands = enum
    Copy,
    Inc,
    Dec,
    JNZ,
    Toggle

const ToggleMap = {Copy:JNZ, Inc:Dec, Dec:Inc, JNZ:Copy, Toggle:Inc}.toTable

type ArgumentType = enum None, Value, Register
type Argument = object
    case argType: ArgumentType
    of Value:
        val: int
    of Register:
        register: int
    else:
        discard

type Puzzle* = enum Day12_Part1, Day12_Part2, Day23_Part1

proc newArgument(arg: string): Argument =
    if arg[0] in {'a','b','c','d'}:
        return Argument(argType: Register, register: cast[int](arg[0])-cast[int]('a'))
    else:
        return Argument(argType: Value, val: parseInt(arg))

type Instruction = tuple[
    command: Commands,
    arg1: Argument,
    arg2: Argument
]

proc day12and23*(mode: Puzzle) =

    var registers: array[4, int]
    var file: string
    case mode:
        of Day12_Part1:
            registers = [0,0,0,0]
            file = "day12"
        of Day12_Part2:
            registers = [0,0,1,0]
            file = "day12"
        of Day23_Part1:
            registers = [7,0,0,0]
            file = "day23"

    proc getValue(arg: Argument): int =
        case arg.argType:
        of Value:
            return arg.val
        of Register:
            return registers[arg.register]
        else:
            doAssert false


    const runSample = false

    let f = open(os.getAppDir() & "\\..\\input\\" & file & (if runSample: "_sample.txt" else: ".txt"))
    defer: f.close()
    var line : string

    var program: seq[Instruction]

    while f.read_line(line):

        var m: RegexMatch
        doAssert line.match(re"(\w+) ([-\w]+)(?: (.*))?", m)

        case m.groupFirstCapture(0,line):
            of "cpy":
                program.add((Copy,newArgument(m.groupFirstCapture(1,line)),newArgument(m.groupFirstCapture(2,line))))
            of "inc":
                program.add((Inc,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
            of "dec":
                program.add((Dec,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
            of "jnz":
                program.add((JNZ,newArgument(m.groupFirstCapture(1,line)),newArgument(m.groupFirstCapture(2,line))))
            of "tgl":
                program.add((Toggle,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
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
        of Toggle:
            let inst = IP + program[IP].arg1.getValue()
            if inst in 0..high(program):
                program[inst].command = ToggleMap[program[inst].command]                   
            inc IP

    echo registers[0]
