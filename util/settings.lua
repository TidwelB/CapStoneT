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

function settings:enter(from)
    self.from = from
end
Mastervolume = .5
font = love.graphics.newFont(32)

Volume = .5
table.insert(buttons,newButton("Return to Pause Menu",function()Gamestate.pop()end))
table.insert(buttons,newButton("Increase Volume",function() settings.increasevolumes(Music.music) end))
--table.insert(buttons,newButton("Increase Volume",function() Volume = Volume - .2  Sounds.collision:setVolume(New) end))
table.insert(buttons,newButton("Decrease Volume",function() settings.decreasevolumes(Music.music) end))
table.insert(buttons,newButton("Increase Sound Effects Volume",function() settings.increasevolumes(Sounds.collision) end))
table.insert(buttons,newButton("Decrease Sound Effects Volume",function() settings.decreasevolumes(Sounds.collision) end))
table.insert(buttons,newButton("Mute Sounds",function() settings.mute() end))

function settings:draw()
    love.graphics.print("Music: " .. math.floor(Music.music:getVolume()*100) .. "%",300,200)
    love.graphics.print("Sound Effects: " .. math.floor(Sounds.collision:getVolume()*100) .. "%",300,250)
    --love.graphics.print("Sound Effect Volume:" Sounds.collision, 300, 250)
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


function settings.mute()
    if Music.music:getVolume() == 0 then
        Music.music:setVolume(Volume)
    elseif Music.music:getVolume() ~= 0 then
        Music.music:setVolume(0)
    end
end

function settings.increasevolumes(param)
    Volume = Volume + .2
    if Volume >= 1 then
        Volume = 1
        param:setVolume(1)
    end
    param:setVolume(Volume)
end

function settings.decreasevolumes(parameter)
    Volume = Volume - .2
    if Volume <= 0 then
        Volume = 0
        parameter:setVolume(0)
    end
    parameter:setVolume(Volume)
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