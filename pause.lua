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
    pause.load()
    love.graphics.clear()
    love.graphics.reset()
   -- love.window.setMode(1024,1024)
    --todo
    --player.load()

end

function pause:update(dt)
    pause.update(dt)
end
font = love.graphics.newFont(32)
--     love.graphics.setBackgroundColor(255,255,255,1)
    table.insert(buttons,newButton("Return to Game",function()Gamestate.pop()end))
    table.insert(buttons,newButton("Settings",function()Gamestate.push(settings)end)) 
function pause:draw()
    love.graphics.reset()
  --local ww,wh = love.graphics.getWidth(),love.graphics.getHeight()
    self.from:draw()
    font = love.graphics.newFont(32)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonwidth = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local total = (BUTTON_HEIGHT+margin) * #buttons
    love.graphics.printf('SETTINGS',0,wh/2,ww,'center')
    for i, buttons in ipairs(buttons) do
        buttons.last = buttons.now
        --love.graphics.setColor(255,255,255,1)
        local x = (ww*.5)-(buttonwidth*.5)
        local y = (wh * .5)-(total * .5)+cursor_y
        local color = {.8,.4,.5,1}
        local mousex, mousey = love.mouse.getPosition()
        local highlight = mousex > x and mousex < x + buttonwidth and mousey > y and mousey < y + BUTTON_HEIGHT

        if highlight then
            color  = {.8,.8,.9,1}
        end

        buttons.now = love.mouse.isDown(1)

        if buttons.now and not buttons.last and highlight then
            buttons.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill",(ww*.5)-(buttonwidth*.5),(wh * .5)-(total * .5)+cursor_y,buttonwidth,BUTTON_HEIGHT)
        love.graphics.setColor(0,0,0,1)
        local textwidth = font:getWidth(buttons.text)
        local textHeight = font:getHeight(buttons.text)
        love.graphics.print(buttons.text,font,(ww*.5)-textwidth*.5,y+textHeight*.5)
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end
    love.graphics.reset()
    --love.graphics.setColor(0,0,0,100)
    --love.graphics.setColor(.4,.4,.5,.1)
   -- love.graphics.rectangle('fill', 0,0,ww,wh)
 --   love.graphics.setColor(255,255,255)
   -- love.graphics.reset()
   -- love.graphics.printf('PAUSED',0,wh/2,ww,'center')
    --love.graphics.printf('To Continue Press: p',0,wh/3,ww,'center')
    --love.graphics.printf('To Exit Press: Escape',0,wh/3+wh/3,ww,'center')
    --love.graphics.printf('To Go To Settings Press: s', 0,wh/5+wh/5,ww,'center')
    if love.keyboard.isDown('s') then
        Gamestate.pop()
        love.graphics.reset()
        Gamestate.push(settings)
        settings.load()
    elseif love.keyboard.isDown('escape') then
        Gamestate.switch(menu)
    end
end

 function pause.load()
--     --Gamestate.switch(pause)

end

function pause:update()
    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
    
end