-- Gamestate library
Gamestate = require 'libraries.gamestate'
pause = {}

function pause:enter()
    --todo
    --player.load()
end
function pause:update(dt)
    pause.update()
end
function pause:draw()
    love.graphics.setColor(0,0,0,1)
end






function pause.update(dt)
    pauseTimer = pauseTimer +dt

    if love.keyboard.isScancodeDown('r') and pauseTimer > .3 then
        pauseTimer = 0
        player.paused=0
        Gamestate.pop(pause)
    end
end
