import bitops
import lists
import sets
import sequtils
import tables

const DAY11_USE_BITMASK = 1
const DAY11_USE_SCORING = 1

#const DAY11_SAMPLE = 0
#const DAY11_PART1 = 0
const DAY11_PART2 = 0

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
type BuildingDefinition = array[4, Floor]
when declared(DAY11_USE_BITMASK):
    type Building = uint64
else:
    type Building = array[4, Floor]
type State = tuple[building: Building, steps: int]

when declared(DAY11_USE_SCORING):
    type StateStore = seq[seq[State]]
else:
    type StateStore = SinglyLinkedList[State]

when declared(DAY11_SAMPLE):
    let initialBuildingDefinition: BuildingDefinition =
        [{Elevator, RutheniumMicrochip, ThuliumMicrochip},
        {RutheniumGenerator},
        {ThuliumGenerator},
        {}]

when declared(DAY11_PART1):
    let initialBuildingDefinition: BuildingDefinition =
        [{Elevator, ThuliumMicrochip, ThuliumGenerator, PlutoniumGenerator, StrontiumGenerator},
        {PlutoniumMicrochip, StrontiumMicrochip},
        {PromethiumGenerator, PromethiumMicrochip, RutheniumGenerator, RutheniumMicrochip},
        {}]

when declared(DAY11_PART2):
    let initialBuildingDefinition: BuildingDefinition =
        [{Elevator, ThuliumMicrochip, ThuliumGenerator, PlutoniumGenerator, StrontiumGenerator, EleriumMicrochip, EleriumGenerator, DilithiumMicrochip, DilithiumGenerator},
        {PlutoniumMicrochip, StrontiumMicrochip},
        {PromethiumGenerator, PromethiumMicrochip, RutheniumGenerator, RutheniumMicrochip},
        {}]

when declared(DAY11_USE_BITMASK):
    const FloorMask: Floor = {ObjectTypes.low..ObjectTypes.high}

const GeneratorMask: Floor = {PlutoniumGenerator,PromethiumGenerator,RutheniumGenerator,StrontiumGenerator,ThuliumGenerator}

proc getFloor(building: Building, floor: int): Floor =
    when declared(DAY11_USE_BITMASK):
        #return cast[Floor](bitand(cast[uint64](FloorMask), building shr cast[uint64](floor * (cast[int](ObjectTypes.high)+1))))
        let sliceStart = floor * (cast[int](ObjectTypes.high)+1)
    else:
        return building[floor]

proc getElevatorFloor(building: Building): int =
    when declared(DAY11_USE_BITMASK):
        for floor in 0..3:
            let elevatorMask = cast[uint64]({ObjectTypes.Elevator}) shl cast[uint64](floor * (cast[int](ObjectTypes.high)+1))
            if bitand(building, elevatorMask) != 0:
                return floor
        doAssert false
    else:
        return map(building, proc (f: Floor): bool = f.contains(Elevator)).find(true)

proc setFloor(building: var Building, floor: int, newFloor: Floor) =
    when declared(DAY11_USE_BITMASK):
        building.clearMask(cast[uint64](FloorMask) shl cast[uint64](floor * (cast[int](ObjectTypes.high)+1)))
        building.setMask(cast[uint64](newFloor) shl cast[uint64](floor * (cast[int](ObjectTypes.high)+1)))
    else:
        building[floor] = newFloor

proc validFloor(floor: Floor): bool =
    if bitand(cast[int](floor), cast[int](GeneratorMask)) != 0:
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

when declared(DAY11_USE_SCORING):
    proc scoreBuilding(building: Building): int =
        var buildingScore = 0

        for floor in 0..3:
            buildingScore += len(building.getFloor(floor)) * floor

        return buildingScore

proc convertDefinition(definition: BuildingDefinition): Building =
    when declared(DAY11_USE_BITMASK):
        var building: Building
        for floor in 0..3:
            building.setFloor(floor, definition[floor])
        return building
    else:
        return cast[Building](definition)

proc convertBuilding(building: Building): BuildingDefinition =
    when declared(DAY11_USE_BITMASK):
        var definition: BuildingDefinition
        for floor in 0..3:
            definition[floor] = building.getFloor(floor)
        return definition
    else:
        return cast[BuildingDefinition](building)

when declared(DAY11_USE_SCORING):
    proc add(stateStore: var StateStore, state: State) =
        let stateScore = scoreBuilding(state.building)
        if stateScore >= len(stateStore):
            stateStore.setLen(stateScore+1)
        stateStore[stateScore].add(state)

proc pop(stateStore: var StateStore): State =
    when declared(DAY11_USE_SCORING):
        let state = stateStore[stateStore.len()-1].pop()
        while stateStore.len() > 0 and stateStore[stateStore.len()-1].len() == 0:
            stateStore.setLen(stateStore.len()-1)
        return state
    else:
        let state = stateStore.head.value
        stateStore.remove(stateStore.head)
        return state


proc day11*() =

    let initialBuilding = convertDefinition(initialBuildingDefinition)
    let goal = bitor(cast[int](initialBuilding.getFloor(0)),cast[int](initialBuilding.getFloor(1)),cast[int](initialBuilding.getFloor(2)),cast[int](initialBuilding.getFloor(3)))

    when declared(DAY11_USE_SCORING):
        var seenBuildings = {initialBuilding:0}.toTable
    else:
        var seenBuildings: HashSet[Building]
        seenBuildings.incl(initialBuilding)

    var statesToConsider: StateStore
    statesToConsider.add((initialBuilding,0))

    var foundSolution = -1

    block mainLoop:
        while true:

            let curState = statesToConsider.pop()

            let elevatorFloor = curState.building.getElevatorFloor()

            if elevatorFloor < 3:
                for newFloors in generateNewFloors(curState.building.getFloor(elevatorFloor), curState.building.getFloor(elevatorFloor + 1)):
                    
                    if elevatorFloor == 2 and cast[int](newFloors.newTo) == goal:
                        if 
                        echo "PART1: " & $(curState.steps + 1)                       
                        break mainLoop

                    var newState = curState
                    newState.building.setFloor(elevatorFloor, newFloors.newFrom)
                    newState.building.setFloor(elevatorFloor+1, newFloors.newTo)
                    when declared(DAY11_USE_SCORING):
                        newState.steps += 1
                        let seenAtStep = seenBuildings.getOrDefault(newState.building, -1)
                        if seenAtStep == -1 or seenAtStep > newState.steps:
                            seenBuildings[newState.building] = newState.steps
                            statesToConsider.add(newState)
                    else:
                        if not seenBuildings.containsOrIncl(newState.building):
                            newState.steps += 1
                            statesToConsider.add(newState)                        
                        

            if elevatorFloor > 0:
                for newFloors in generateNewFloors(curState.building.getFloor(elevatorFloor), curState.building.getFloor(elevatorFloor - 1)):

                    var newState = curState
                    newState.building.setFloor(elevatorFloor, newFloors.newFrom)
                    newState.building.setFloor(elevatorFloor-1, newFloors.newTo)
                    when declared(DAY11_USE_SCORING):
                        newState.steps += 1
                        let seenAtStep = seenBuildings.getOrDefault(newState.building, -1)
                        if seenAtStep == -1 or seenAtStep > newState.steps:
                            seenBuildings[newState.building] = newState.steps
                            statesToConsider.add(newState)
                    else:
                        if not seenBuildings.containsOrIncl(newState.building):
                            newState.steps += 1
                            statesToConsider.add(newState)          