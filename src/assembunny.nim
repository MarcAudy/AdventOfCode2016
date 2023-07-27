import regex
import strutils
import tables

type Commands = enum
    Copy,
    Inc,
    Dec,
    JNZ,
    Toggle,
    Out

const ToggleMap = {Copy:JNZ, Inc:Dec, Dec:Inc, JNZ:Copy, Toggle:Inc, Out:Inc}.toTable

type ArgumentType = enum None, Value, Register
type Argument = object
    case argType: ArgumentType
    of Value:
        val: int
    of Register:
        register: int
    else:
        discard

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

type ABMRegisters* = array[4,int]

type AssembunnyMachine* = object
    registers: ABMRegisters
    program: seq[Instruction]
    output: seq[int]

proc newABM*(sourceFile: string): AssembunnyMachine =

    var ABM: AssembunnyMachine

    let f = open(sourceFile)
    defer: f.close()
    var line : string

    while f.read_line(line):

        var m: RegexMatch
        doAssert line.match(re"(\w+) ([-\w]+)(?: (.*))?", m)

        case m.groupFirstCapture(0,line):
            of "cpy":
                ABM.program.add((Copy,newArgument(m.groupFirstCapture(1,line)),newArgument(m.groupFirstCapture(2,line))))
            of "inc":
                ABM.program.add((Inc,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
            of "dec":
                ABM.program.add((Dec,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
            of "jnz":
                ABM.program.add((JNZ,newArgument(m.groupFirstCapture(1,line)),newArgument(m.groupFirstCapture(2,line))))
            of "tgl":
                ABM.program.add((Toggle,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))
            of "out":
                ABM.program.add((Out,newArgument(m.groupFirstCapture(1,line)),Argument(argType:None)))           
            else:
                doAssert false

    return ABM

proc getRegisters*(this: AssembunnyMachine): ABMRegisters =
    return this.registers

proc getOutput*(this: AssembunnyMachine): seq[int] =
    return this.output

proc getArgValue(this: AssembunnyMachine, arg: Argument): int =
    case arg.argType:
    of Value:
        return arg.val
    of Register:
        return this.registers[arg.register]
    else:
        doAssert false

proc run*(this: var AssembunnyMachine, startRegisters: ABMRegisters, outputLimit: int = 0) =

    this.registers = startRegisters
    this.output.setLen(0)

    var IP = 0
    while IP < this.program.len():
        case this.program[IP].command:
        of Copy:
            this.registers[this.program[IP].arg2.register] = this.getArgValue(this.program[IP].arg1)
            inc IP
        of Inc:
            inc this.registers[this.program[IP].arg1.register]
            inc IP
        of Dec:
            dec this.registers[this.program[IP].arg1.register]
            inc IP
        of JNZ:
            if this.getArgValue(this.program[IP].arg1) != 0:
                IP += this.getArgValue(this.program[IP].arg2)
            else:
                inc IP
        of Toggle:
            let inst = IP + this.getArgValue(this.program[IP].arg1)
            if inst in 0..high(this.program):
                this.program[inst].command = ToggleMap[this.program[inst].command]                   
            inc IP
        of Out:
            this.output.add(this.getArgValue(this.program[IP].arg1))
            if this.output.len() == outputLimit:
                return
            inc IP