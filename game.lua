-- Gamestate library
Gamestate = require 'libraries.gamestate'
game = {}
menu = {}
require("enemy")
require("player")
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
    testingMap = sti('maps/testingzone2.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})

    -- Player table: 
    --          Contains player information 
    player.load()

    -- Player Animation table: 
    --          Contains animations and assigns them to their given direction
    
    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 4), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    player.anim = player.animations.left
        
    
    -- Initializes player animations and allows the movment keys to 
    -- influence which animation plays
    

    timer = 0
    
    enemy.spawn(400,250)
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


    UPDATE_ENEMY(dt)


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
         world:draw()
    camera:detach()

    DRAW_ENEMY()
end