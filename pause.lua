-- Gamestate library
Gamestate = require 'libraries.gamestate'
pause = {}
pause = Gamestate.new()
local buttons = {}
BUTTON_HEIGHT = 64
local font = nil
local function newButton(text,fn)
    return{
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end
function pause:enter(from)
    self.from = from
   -- love.window.setMode(1024,1024)
    --todo
    --player.load()

end
function pause:update(dt)
    pause.update(dt)
end
function pause:draw()
    love.graphics.reset()
  local ww,wh = love.graphics.getWidth(),love.graphics.getHeight()
    self.from:draw()
    font = love.graphics.newFont(32)
    --love.graphics.setColor(0,0,0,100)
    --love.graphics.setColor(.4,.4,.5,.1)
   -- love.graphics.rectangle('fill', 0,0,ww,wh)
 --   love.graphics.setColor(255,255,255)
   -- love.graphics.reset()
    love.graphics.printf('PAUSED',0,wh/2,ww,'center')
    love.graphics.printf('To Continue Press: p',0,wh/3,ww,'center')
    love.graphics.printf('To Exit Press: Escape',0,wh/3+wh/3,ww,'center')
    if love.keyboard.isDown('escape') then
        Gamestate.switch(menu)
    end
end

-- function pause:load()
   
--     --Gamestate.switch(pause)
--     font = love.graphics.newFont(32)
--     love.graphics.setBackgroundColor(255,255,255,1)
--     table.insert(buttons,newButton("Game",function()love.event.quit(0)end))
--     table.insert(buttons,newButton("Sadness",function()love.event.quit(0)end))
-- ends

function pause:update()

    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
    
end