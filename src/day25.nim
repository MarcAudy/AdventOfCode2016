import assembunny
import os

proc day25*() =

    var registers: ABM_Registers = [1,0,0,0]
    var ABM = newABM(os.getAppDir() & "\\..\\input\\day25.txt")

    while true:
        ABM.run(registers, 20)
        let results = ABM.getOutput()

        var success = true
        for i in 0..high(results):
            if i %% 2 != results[i]:
                success = false
                break

        if success:
            echo "DAY25: ", registers[0]
            break
            
        inc registers[0]
    
