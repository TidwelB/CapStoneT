transition = {}
Gamestate = require 'libraries.gamestate'



function sleep (a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

function transition:Transitioner()
    if player.collider:enter('Ghost') then
        transition:update()
        transition:update()
        sleep(1)
        return Gamestate.switch(runLevelOne)
    end
end

function transition:update(dt)
    for i = 1, 5 do
        camera:zoom(1.05)
    end
end


return transition