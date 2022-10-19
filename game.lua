-- Gamestate library
Gamestate = require 'libraries.gamestate'
game = {}
menu = {}
require("enemy")
require("player")
require("shaders")
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
    enemy.load()

    -- Player Animation table: 
    --          Contains animations and assigns them to their given direction
    
    -- player.animations = {}
    -- player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    -- player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    -- player.animations.right = anim8.newAnimation( player.grid('1-4', 4), 0.2 )
    -- player.animations.up = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
    -- player.anim = player.animations.left
        
    
    -- Initializes player animations and allows the movment keys to 
    -- influence which animation plays
    

    timer = 0
    
    enemy.spawn(500,500)
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
    player:update(dt)
    player.anim:update(dt)
    heartbeat.anim:update(dt)
    enemy.anim:update(dt)
    timer = timer + dt
    UPDATE_ENEMY(dt)

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   shaders:update(dt)

end

function game:draw()
    -- Tells the game where to start looking through the camera POV
    
    camera:attach()
        testingMap:drawLayer(testingMap.layers["Tile Layer 1"])
        testingMap:drawLayer(testingMap.layers["grate"])
        testingMap:drawLayer(testingMap.layers["Walls"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
        -- if you want to see the hitboxes for the map and the player uncomment the line below
            -- Tells the game where to start looking through the camera POV
        love.graphics.setShader(shaders.trueLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()
        world:draw()
        
    camera:detach()
    love.graphics.reset()
    DRAW_HUD()
    DRAW_ENEMY()
end