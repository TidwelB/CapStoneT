-- Gamestate library
Gamestate = require 'libraries.gamestate'
local menu = {}
local game = {}
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
function menu:enter()
    table.insert(buttons,newButton("Start Game",function()Gamestate.switch(game)end))
    table.insert(buttons,newButton("Exit",function()love.event.quit(0)end))
end
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
    love.window.setMode(1920, 1080)

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

function game:update(dt)
    timer = timer + dt

    local isMoving = false

    local vx = 0;
    local vy = 0;

    -- Player Movement
   if love.keyboard.isDown("d") then
       vx = player.speed
       player.anim = player.animations.right
       isMoving = true
   end
   if love.keyboard.isDown("a") then
       vx = player.speed * -1
       player.anim = player.animations.left
       isMoving = true
   end
   if love.keyboard.isDown("s") then
       vy = player.speed
       player.anim = player.animations.down
       isMoving = true
   end
   if love.keyboard.isDown("w") then
       vy = player.speed * -1
       player.anim = player.animations.up
       isMoving = true
   end

   -- Sets the players hitbox to move with where our 
   -- player is currently moving
   player.collider:setLinearVelocity(vx, vy)

   -- switches game back into the main menu
   if love.keyboard.isDown("escape") then
        Gamestate.switch(menu)
   end

   -- Freezes the frame on the idle sprite in that direction
   if (isMoving == false) then
        player.anim:gotoFrame(3)
   end

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   player.x = player.collider:getX()
   player.y = player.collider:getY()

   player.anim:update(dt)

end

function game:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["Tile Layer 1"])
        testingMap:drawLayer(testingMap.layers["grate"])
        testingMap:drawLayer(testingMap.layers["Walls"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)

        -- if you want to see the hitboxes for the map and the player uncomment the line below
        -- world:draw()
    camera:detach()
end

-- prepares the game for switches
function love.load()
    Gamestate.registerEvents()
    font = love.graphics.newFont(32)
    Gamestate.switch(menu)   
end