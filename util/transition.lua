transition = {}
Gamestate = require 'libraries.gamestate'

function sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

function transition:Transitioner()
    if player.collider:enter('Ghost') then
        if player.x > 1300 and player.x < 1550 and room =="levelOne" then
            room = "runGame"
            return Gamestate.switch(runGame)
        end
print(player.x)
print(player.y)
        --transition:update()
print(Gamestate.current() == runGame)
        if Gamestate.current() == runGame and player.y < 300 then
            room = "levelOne"
            rock.collider:destroy()
            return Gamestate.switch(runLevelOne)
        else if Gamestate.current() == runGame then
            room = "levelTwo"
            rock.collider:destroy()
            return Gamestate.switch(runLevelTwo)
        end
        end

        if Gamestate.current() == runLevelTwo and player.y > 1400 then
            print("yea i tried")
            room = "levelThree"
            rock.collider:destroy()
            return Gamestate.switch(runLevelThree)
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