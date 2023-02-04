-- Gamestate library
Gamestate = require 'libraries.gamestate'

game = {}
menu = {}

require("enemy")
require("player")
require("shaders")
local testing = require("testing.testing")
range = 100


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
    camera:zoom(2)
    -- loads in the map
    testingMap = sti('maps/mainlobby.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setTitle("SCP: FALLEN")
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})

    --enemy.spawn(500,500)

    --  Walls table: 
    --          intializes the hitboxes for the map 
    --          whether that be the walls, the green stuff, etc...
    world:addCollisionClass('Solid')
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})

rock = {}
    rock.spritesheet = love.graphics.newImage("sprites/rock.png")
    rock.x = 400
    rock.y = 400
    rock.h = rock.spritesheet:getHeight()
    rock.w = rock.spritesheet:getWidth()
    rock.collider = world:newBSGRectangleCollider(400, 400, rock.h, rock.w, 14)

gengar = {}
    gengar.spritesheet = love.graphics.newImage("sprites/gengar.png")
    gengar.x = 200
    gengar.y = 200
    gengar.h = gengar.spritesheet:getHeight()
    gengar.w= gengar.spritesheet:getWidth()

flashlight = {}
    flashlight.spritesheet = love.graphics.newImage("sprites/flashlight.png")
    flashlight.x = 500
    flashlight.y = 200
    flashlight.h = flashlight.spritesheet:getHeight()
    flashlight.w = flashlight.spritesheet:getWidth()
    flashlight.scale = 0.1

    walls = {}

        if testingMap.layers["Walls"] then
            for i, box in pairs(testingMap.layers["Walls"].objects) do
                local wall = world:newRectangleCollider(box.x, box.y, box.width, box.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end

    transitions = {}
        if testingMap.layers["Transitions"] then
            for i, obj in pairs(testingMap.layers["Transitions"].objects) do
                local transition = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                transition:setType('static')
                transition:setCollisionClass('Ghost')
                table.insert(transitions,transition)
            end
        end

        player.load()
        --enemy.load()
        
        timer = 0
end

function game:update(dt)
    player:update(dt)
    player.anim:update(dt)

    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:update(dt)
    end

   -- enemy.anim:update(dt)
    timer = timer + dt
    --UPDATE_ENEMY(dt)
    

    game.height = love.graphics.getHeight()
    game.width = love.graphics.getWidth()

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   shaders:update(dt)
end




function game:draw()
    -- Tells the game where to start looking through the camera POV

    camera:attach()


        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["barrier"])
        testingMap:drawLayer(testingMap.layers["water"])
        testingMap:drawLayer(testingMap.layers["objects"])
        testingMap:drawLayer(testingMap.layers["chairs"])


        if checkInventory(inventory, "gengar") == false then
        love.graphics.draw(gengar.spritesheet,gengar.x,gengar.y)
        end
        if checkInventory(inventory, "flashlight") == false then
            love.graphics.draw(flashlight.spritesheet,flashlight.x,flashlight.y,0,flashlight.scale,flashlight.scale)
        end

        --ROCK
        if checkInventory(inventory, "rock") == false then
        rock.x = rock.collider:getX() 
        rock.y = rock.collider:getY() 
        love.graphics.draw(rock.spritesheet, rock.x, rock.y, rock.collider:getAngle(), 1, 1, rock.w/2, rock.h/2)
        local x, y = rock.collider:getLinearVelocity()
        local w = rock.collider:getAngularVelocity()
        if (math.random(0,range) == 1) then
            x = x * 0.33
            y = y * 0.33
            w = w * 0.33
            range = range / 1.5
            if range < 10 then
                range = 100
            end
        end
        rock.collider:setAngularVelocity(w)
        rock.collider:setLinearVelocity(x, y)
    end
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, nil, 6, 6)
        --enemy.draw()
        love.graphics.print("Press W to walk upwards", 300, 200)
        love.graphics.print("Press S to walk downwards", 300, 250)
        love.graphics.print("Press A to walk left", 200, 225)
        love.graphics.print("Press D to walk right", 400, 225)
        love.graphics.print("Press P to pause", 550, 225)
        love.graphics.print("Press F to use flashlight",550, 260)
        love.graphics.print("Hold Shift to sprint", 900, 700)
        love.graphics.print("Go this way ---->", 440, 630)
        love.graphics.print("Go down to move to next area", 2000, 1400)

        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()
        --world:draw()


    camera:detach()
    love.graphics.reset()

    DRAW_HUD()
    --DRAW_ENEMY()


    --testing.run()
end