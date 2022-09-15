require("game")
-- Gamestate library
Gamestate = require 'libraries.gamestate'
menu = {}
runGame = {}

local buttons = {}
local test = {}

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
-- Initializes the main menu at a very basic level
function menu:draw()
    --This is creating the main menu buttons and their funtions
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonwidth = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local total = (BUTTON_HEIGHT+margin) * #buttons
    for i, buttons in ipairs(buttons) do
        buttons.last = buttons.now
        love.graphics.setColor(0.4,.4,.5,1)
        local x = (ww*.5)-(buttonwidth*.5)
        local y = (wh * .5)-(total * .5)+cursor_y
        local color = {.4,.4,.5,1}
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
end

function runGame:enter()
    game.enter(self)
end
function runGame:update(dt)
    game.update(self, dt)
end
function runGame:draw()
    game.draw(self)
end

-- prepares the game for switches
function love.load()
    Gamestate.registerEvents()
    font = love.graphics.newFont(32)
    Gamestate.switch(menu) 
    table.insert(buttons,newButton("Start Game",function()Gamestate.switch(runGame)end))
    table.insert(buttons,newButton("Exit",function()love.event.quit(0)end))
end