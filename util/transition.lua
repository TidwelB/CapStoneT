transition = {}
Gamestate = require 'libraries.gamestate'
transition.coordx = nil
transition.coordy = nil
function sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

function transition:Transitioner()
    if player.collider:enter('Ghost') then
        --LevelOne to Main lobby
        if player.x > 1300 and player.x < 1550 and room =="levelOne" then
            rock.delete()
            room = "runGame"
            transition.coordx = 405
            transition.coordy = 142
            return Gamestate.switch(runGame)
        end
print(player.x)
print(player.y)
        --transition:update()
print(Gamestate.current() == runGame)

        -- Main lobby to LevelOne
        if Gamestate.current() == runGame and player.y < 300 then
            rock.delete()
            transition.coordx = 1430
            transition.coordy = 3000
            room = "levelOne"
            
            -- rock.collider:destroy()
            -- rock.collider = nil
            return Gamestate.switch(runLevelOne)
        --Main lobby to LevelTwo
        else if Gamestate.current() == runGame then
            rock.delete()
            room = "levelTwo"
            transition.coordx = 831
            transition.coordy = 120
            return Gamestate.switch(runLevelTwo)
        end
        end

        if Gamestate.current() == runLevelTwo and player.y > 1400 then
            --print("yea i tried")

            --if checkInventory(inventory,"chargecable") then
                rock.delete()
                room = "levelThree"
                transition.coordx = 862
                transition.coordy = 144
            return Gamestate.switch(runLevelThree)
            --end
        else if Gamestate.current() == runLevelTwo then
            transition.coordx = 468
            transition.coordy = 780
            room = "runGame"
            Gamestate.switch(runGame)
        end
        end

        if Gamestate.current() == runLevelThree and player.y <300 then
            rock.delete()
            room = "levelTwo"
            transition.coordx = 831
            transition.coordy = 1420
            return Gamestate.switch(runLevelTwo)
        end




        --1 - main  1349,1324
        --2 - main   738, 5.33
        --2 - 3      742,1512
        --2 - maze      777,10
        --3 - 4      774,1508
        --4 - 3     775, 10

    end
end

function transition:update(dt)
    for i = 1, 5 do
        camera:zoom(1.05)
    end
end

return transition