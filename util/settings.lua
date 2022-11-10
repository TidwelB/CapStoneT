Gamestate = require 'libraries.gamestate'

settings = {}
settings = Gamestate.new()

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

--function settings:enter()
  --  settings.load()
--end
font = love.graphics.newFont(32)
table.insert(buttons,newButton("Penis",function()Gamestate.switch(runGame)end))
table.insert(buttons,newButton("Exit",function()love.event.quit(0)end))
function settings:draw()
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
    
   
--resets the color so that it doesnt have a black screen (very important please dont delete)
    love.graphics.reset()
    if love.keyboard.isDown('m') then
        Gamestate.pop()
    end
    if love.keyboard.isDown('y') then
        Gamestate.switch(menu)
    end
end

--DOESNT GET HERE
function settings.load()
  
end

function settings:update()
    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
end