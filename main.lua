require("game")
require('tutorial')
require('levelOne')
require('maze')
require('levelTwo')
-- Gamestate library
Gamestate = require 'libraries.gamestate'
menu = {}
runGame = {}
runTutorial = {}
runLevelOne = {}
runMaze = {}
runLevelTwo = {}

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

function game:enter()
    -- Hitbox library
    wf = require 'libraries/windfield'
    -- Tiled implementation library
    sti = require 'libraries/sti'
    -- Animations library
    anim8 = require 'libraries/anim8'
    -- Camera library
    cam = require 'libraries/camera'

    -- Makes the character stretch not blurry 
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    camera = cam()

    -- loads in the map
    testingMap = sti('maps/testing-zone.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setMode(1280, 920, {resizable=true, vsync=0, minwidth=400, minheight=300})

    -- Player table: 
    --          Contains player information 
    player = {}

        player.collider = world:newBSGRectangleCollider(400, 250, 65, 100, 14)
        player.collider:setFixedRotation(true)
        player.x = 0
        player.y = 0
        player.speed = 250
        player.spriteSheet = love.graphics.newImage('sprites/guard_yellow_spritesheet.png')
        player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    -- Player Animation table: 
    --          Contains animations and assigns them to their given direction
    player.animations = {}
        
        player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
        player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
        player.animations.right = anim8.newAnimation( player.grid('1-4', 4), 0.2 )
        player.animations.up = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    
    -- Initializes player animations and allows the movment keys to 
    -- influence which animation plays
    player.anim = player.animations.left

    timer = 0
    
    --  Walls table: 
    --          intializes the hitboxes for the map 
    --          whether that be the walls, the green stuff, etc...
    walls = {}

        if testingMap.layers["walls"] then
            for i, box in pairs(testingMap.layers["walls"].objects) do
                local wall = world:newRectangleCollider(box.x, box.y, box.width, box.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end

end

-- Code for executing the main lobby of the game
function runGame:enter()
    game.enter(self)
end
function runGame:update(dt)
    game.update(self, dt)
end
function runGame:draw()
    game.draw(self)
end

-- Code for executing the first stage of the game
function runLevelOne:enter()
    levelOne.enter(self)
end
function runLevelOne:update(dt)
    levelOne.update(self, dt)
end
function runLevelOne:draw()
    levelOne.draw(self)
end

-- Code for executing the maze section
function runMaze:enter()
    maze.enter(self)
end
function runMaze:update(dt)
    maze.update(self, dt)
end
function runMaze:draw()
    maze.draw(self)
end

-- Code for executing the second stage of the game
function runLevelTwo:enter()
    levelTwo.enter(self)
end
function runLevelTwo:update(dt)
    levelTwo.update(self, dt)
end
function runLevelTwo:draw()
    levelTwo.draw(self)
end

-- prepares the game for switches
function love.load()
    Gamestate.registerEvents()
    font = love.graphics.newFont(32)
    Gamestate.switch(menu) 
    table.insert(buttons,newButton("Start Game",function()Gamestate.switch(runGame)end))
    table.insert(buttons,newButton("Exit",function()love.event.quit(0)end))
end