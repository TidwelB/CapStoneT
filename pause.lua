-- Gamestate library
Gamestate = require 'libraries.gamestate'
pause = {}
pause = Gamestate.new()

function pause:enter(from)
    self.from = from
    --todo
    --player.load()

end
function pause:update(dt)
    pause.update(dt)
end
function pause:draw()
    local w,h = love.graphics.getWidth(),love.graphics.getHeight()
    --self.from:draw()

    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle('fill', 0,0,w,h)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('PAUSE',0,h/2,w,'center')
end




function pause.update(dt)

    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
end