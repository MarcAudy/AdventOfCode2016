import lists
import sets
import sequtils

type ObjectTypes = enum
    Elevator
    PlutoniumGenerator
    PromethiumGenerator
    RutheniumGenerator
    StrontiumGenerator
    ThuliumGenerator
    EleriumGenerator
    DilithiumGenerator
    PlutoniumMicrochip
    PromethiumMicrochip
    RutheniumMicrochip
    StrontiumMicrochip
    ThuliumMicrochip
    EleriumMicrochip
    DilithiumMicrochip

type Floor = set[ObjectTypes]
type Building = array[4, Floor]
type State = tuple[building: Building, steps: int]

let sampleInitialBuilding: Building =
    [{Elevator, RutheniumMicrochip, ThuliumMicrochip},
     {RutheniumGenerator},
     {ThuliumGenerator},
     {}]

let problemInitialBuilding: Building =
    [{Elevator, ThuliumMicrochip, ThuliumGenerator, PlutoniumGenerator, StrontiumGenerator},
     {PlutoniumMicrochip, StrontiumMicrochip},
     {PromethiumGenerator, PromethiumMicrochip, RutheniumGenerator, RutheniumMicrochip},
     {}]

let problemPart2InitialBuilding: Building =
    [{Elevator, ThuliumMicrochip, ThuliumGenerator, PlutoniumGenerator, StrontiumGenerator, EleriumMicrochip, EleriumGenerator, DilithiumMicrochip, DilithiumGenerator},
     {PlutoniumMicrochip, StrontiumMicrochip},
     {PromethiumGenerator, PromethiumMicrochip, RutheniumGenerator, RutheniumMicrochip},
     {}]

var seenBuildings: HashSet[Building]

const GeneratorMask: Floor = {PlutoniumGenerator,PromethiumGenerator,RutheniumGenerator,StrontiumGenerator,ThuliumGenerator}

proc validFloor(floor: Floor): bool =
    if len(floor * GeneratorMask) > 0:
        if (PlutoniumMicrochip in floor) and (PlutoniumGenerator notin floor):
            return false
        if (PromethiumMicrochip in floor) and (PromethiumGenerator notin floor):
            return false
        if (RutheniumMicrochip in floor) and (RutheniumGenerator notin floor):
            return false
        if (StrontiumMicrochip in floor) and (StrontiumGenerator notin floor):
            return false
        if (ThuliumMicrochip in floor) and (ThuliumGenerator notin floor):
            return false
        if (EleriumMicrochip in floor) and (EleriumGenerator notin floor):
            return false
        if (DilithiumMicrochip in floor) and (DilithiumGenerator notin floor):
            return false
    return true

iterator generateNewFloors(fromFloor: Floor, toFloor: Floor): tuple[newFrom: Floor, newTo: Floor] =
    
    # elevator always moves
    let baseNewFrom = fromFloor - {Elevator}
    let baseNewTo = toFloor + {Elevator}

    let fromObjects = toSeq(baseNewFrom)
    for i in 0..<len(fromObjects):

        # one object only
        let oneObjFrom = baseNewFrom - {fromObjects[i]}
        let oneObjTo = baseNewTo + {fromObjects[i]}
        if validFloor(oneObjTo):
            yield (oneObjFrom, oneObjTo)

        for j in i+1..<len(fromObjects):
            let twoObjTo = oneObjTo+{fromObjects[j]}
            if validFloor(twoObjTo):
                yield (oneObjFrom-{fromObjects[j]},twoObjTo)

proc day11*() =

    #let initialBuilding = sampleInitialBuilding
    #let initialBuilding = problemInitialBuilding
    let initialBuilding = problemPart2InitialBuilding

    let goalCount = foldl(initialBuilding, a + len(b), 0)

    seenBuildings.incl(initialBuilding)
    var statesToConsider: SinglyLinkedList[State] 
    statesToConsider.add((initialBuilding,0))

    block mainLoop:
        while statesToConsider.head != nil:

            let curState = statesToConsider.head.value
            statesToConsider.remove(statesToConsider.head)

            let elevatorFloor = map(curState.building, proc (f: Floor): bool = f.contains(Elevator)).find(true)

            if elevatorFloor < 3:
                for newFloors in generateNewFloors(curState.building[elevatorFloor], curState.building[elevatorFloor + 1]):
                    
                    if elevatorFloor == 2 and len(newFloors.newTo) == goalCount:
                        echo "PART1: " & $(curState.steps + 1)                       
                        break mainLoop

                    var newState = curState
                    newState.building[elevatorFloor] = newFloors.newFrom
                    newState.building[elevatorFloor+1] = newFloors.newTo
                    if not seenBuildings.containsOrIncl(newState.building):
                        seenBuildings.incl(newState.building)
                        newState.steps += 1
                        statesToConsider.add(newState)

            if elevatorFloor > 0:
                for newFloors in generateNewFloors(curState.building[elevatorFloor], curState.building[elevatorFloor - 1]):

                    var newState = curState
                    newState.building[elevatorFloor] = newFloors.newFrom
                    newState.building[elevatorFloor-1] = newFloors.newTo
                    if not seenBuildings.containsOrIncl(newState.building):
                        seenBuildings.incl(newState.building)
                        newState.steps += 1
                        statesToConsider.add(newState)
        