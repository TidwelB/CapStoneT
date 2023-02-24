-- Gamestate library

Gamestate = require 'libraries.gamestate'
levelThree = {}
walls = {}
require('game')
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.rock")

function levelThree:enter()
    room = "levelThree"
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
    testingMap = sti('maps/level3.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setTitle("SCP: FALLEN")
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})
    --wenemy.spawn(500,500)
    --  Walls table: 
    --          intializes the hitboxes for the map 
    --          whether that be the walls, the green stuff, etc...
    world:addCollisionClass('Solid')
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})



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

    -- rock = {}
    --     rock.spritesheet = love.graphics.newImage("sprites/rock.png")
    --     rock.x = 400
    --     rock.y = 400
    --     rock.h = rock.spritesheet:getHeight()
    --     rock.w = rock.spritesheet:getWidth()
    --     rock.collider = world:newBSGRectangleCollider(400, 400, rock.h, rock.w, 14)
    
    -- gengar = {}
    --     gengar.spritesheet = love.graphics.newImage("sprites/gengar.png")
    --     gengar.x = 200
    --     gengar.y = 200
    --     gengar.h = gengar.spritesheet:getHeight()
    --     gengar.w= gengar.spritesheet:getWidth()
    
    -- flashlight = {}
    --     flashlight.spritesheet = love.graphics.newImage("sprites/flashlight.png")
    --     flashlight.x = 500
    --     flashlight.y = 200
    --     flashlight.h = flashlight.spritesheet:getHeight()
    --     flashlight.w = flashlight.spritesheet:getWidth()
    --     flashlight.scale = 0.1

        if saveLoad == true then
            print(saveLoad)
            --player.load(data.position.x,data.position.y)
        else
        print(saveLoad)
        player.load()
        end
        --enemy.load()
        --SCP.load()
        
        
end

function levelThree:update(dt)
    
    player:update(dt)
    player.anim:update(dt)

    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:update(dt)
    end
    --enemy.anim:update(dt)
    --UPDATE_ENEMY(dt)
    --UPDATE_SCP(dt)

if player.y > 270 and player.y < 295 then
    if player.x > 382 and player.x < 457 then
        if love.keyboard.isDown('e') then
            Gamestate.push(greenmon)
        end
    end
else 
    if player.x < 328 and player.x > 183 then
        if love.keyboard.isDown('e') then
            Gamestate.push(pause)
        end
    end
end


   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   shaders:update(dt)
   

end

function levelThree:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["walls"])
        testingMap:drawLayer(testingMap.layers["walls2"])
        testingMap:drawLayer(testingMap.layers["puzzlelock"])
        testingMap:drawLayer(testingMap.layers["items"])
        --testingMap:drawLayer(testingMap.layers["bluepuzzlelock"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
       --enemy.draw()

        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()
        world:draw()
        --gengar.draw("levelThree")
        --flashlight.draw("levelThree")

        love.graphics.setColor(255,255,255,255)
        --love.graphics.rectangle('fill', 400,200,size,size,14)
        --DRAW_SCP()
        if love.keyboard.isDown("j") then
            table.insert(inventory,"Itemsssssss")
        end
    camera:detach()
    love.graphics.reset()
    DRAW_HUD()

end