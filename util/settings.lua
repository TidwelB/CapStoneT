Gamestate = require 'libraries.gamestate'

settings = {}
settings = Gamestate.new()

--volume = .2
BUTTON_HEIGHT = 64
local font = love.graphics.newFont(32)
local button1 = {text = "Return to Pause Menu", fn = function()Gamestate.pop()end, width = 150, x = 450, y = 100}
local button2 = {text = "Increase Volume", fn = function() settings.increasevolumes(Music.music) end, width = 150, x = 450, y = 200}
local button3 = {text = "Decrease Volume", fn = function() settings.decreasevolumes(Music.music) end, width = 150, x = 900, y = 200}
local button4 = {text = "Increase Sound Effect Volumes", fn = function() settings.increasevolumes(Sounds.collision) end, width = 150, x = 450, y = 400}
local button5 = {text = "Decrease Sound Effect Volumes", fn = function() settings.decreasevolumes(Sounds.collision) end, width = 150, x = 900, y = 400}
local button6 = {text = "Mute Sounds", fn = function() settings.mute() end, width = 150, x = 900, y = 100}
local allButtons = {button1,button2,button3,button4,button5,button6}
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

MVolume = .2
CVolume = .2
mute = false
--table.insert(buttons,newButton("Return to Pause Menu",function()Gamestate.pop()end))
--table.insert(buttons,newButton("Increase Volume",function() settings.increasevolumes(Music.music) end))
--table.insert(buttons,newButton("Increase Volume",function() Volume = Volume - .2  Sounds.collision:setVolume(New) end))
--table.insert(buttons,newButton("Decrease Volume",function() settings.decreasevolumes(Music.music) end))
--table.insert(buttons,newButton("Increase Sound Effects Volume",function() settings.increasevolumes(Sounds.collision) end))
--table.insert(buttons,newButton("Decrease Sound Effects Volume",function() settings.decreasevolumes(Sounds.collision) end))
--table.insert(buttons,newButton("Mute Sounds",function() settings.mute() end))
function settings:draw()
    --love.graphics.printf("PENIS",100,200)
   -- love.graphics.print(Volume,100,300,300)
    love.graphics.printf(("Music: " .. math.floor(Music.music:getVolume()*100) .. "%"),100,200,200)
    love.graphics.printf("Sound Effects: " .. math.floor(Sounds.collision:getVolume()*100) .. "%",100,400,400)
    for i, v in ipairs(inventory) do
        love.graphics.print(string.format(i .. ": " .. v .. '\n'),300,225*i)
    end
    local mousex, mousey = love.mouse.getPosition()
    for i, button in ipairs(allButtons) do
        local color = {.8,.4,.5,1}
        local highlight = mousex > button.x and mousex < button.x + button.width and mousey > button.y and mousey < button.y + BUTTON_HEIGHT
        if highlight then
            color = {.8,.8,.9,1}
            if love.mouse.isDown(1) then
                button.fn()
            end
        end
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", button.x, button.y, button.width, BUTTON_HEIGHT)
        love.graphics.setColor(0,0,0,1)
        love.graphics.printf(button.text, button.x, button.y, button.width, "center")
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
    love.timer.sleep(.15)
    if mute == false then
        mute = true
    elseif mute == true then
        mute = false
    end
    -- if Music.music:getVolume() == 0 and Sounds.collision:getVolume() == 0 then
    --     Music.music:setVolume(Volume)
    --     Sounds.collision:setVolume(Volume)
    -- elseif Music.music:getVolume() ~= 0 and Sounds.collision:getVolume() == 0 then
    --     Music.music:setVolume(0)
    --     Sounds.collision:setVolume(Volume)
    -- elseif Music.music:getVolume() ~= 0 and Sounds.collision:getVolume() ~= 0 then
    --     Music.music:setVolume(0)
    --     Sounds.collision:setVolume(0)
    -- elseif Music.music:getVolume() == 0 and Sounds.collision:getVolume() ~= 0 then
    --     Music.music:setVolume(Volume)
    --     Sounds.collision:setVolume(0)
    if mute == false then
            Music.music:setVolume(TemMu)
            Sounds.collision:setVolume(TemCol)
    end

    if mute == true then
        TemMu = Music.music:getVolume()
        TemCol = Sounds.collision:getVolume()
        Music.music:setVolume(0)
        Sounds.collision:setVolume(0)

    end
    -- if Music.music:getVolume() == 0 then
    --     Music.music:setVolume(Volume)
    -- elseif Music.music:getVolume() ~= 0 then
    --     Music.music:setVolume(0)
    --     Sounds.collision:setVolume(Volume)
    -- end
end

-- function settings:increasevolumes(param,volume)
--     volume = volume + .2
--     param.setVolume(volume)
--     return volume
-- end

function settings.increasevolumes(param)
    love.timer.sleep(.15)
    local vom
        vom = param:getVolume()
        vom = vom + .1
        param:setVolume(vom)
        if vom > 1 then
            vom = 1
        end
    param:setVolume(vom)
end

function settings.decreasevolumes(parameter)
    local vom
    love.timer.sleep(.15)
        vom = parameter:getVolume()
        vom = vom - .1
        parameter:setVolume(vom)
        if vom <= 0 then
            vom = 0
        end
    parameter:setVolume(vom)
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