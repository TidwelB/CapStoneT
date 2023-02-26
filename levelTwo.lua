-- Gamestate library

Gamestate = require 'libraries.gamestate'
levelTwo = Gamestate.new()
levelTwo = {}
walls = {}
require('util.wavegen.waver')
require('util.wavegen.waver2')
require('util.wavegen.waver3')
require('util.wavegen.waver4')
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.rock")

function levelTwo:enter()
    room = "levelTwo"
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
    testingMap = sti('maps/level2.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setTitle("SCP: FALLEN")
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})

    world:addCollisionClass('Solid')
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})
    world:addCollisionClass('Ignore', {ignores = {'Solid'}})

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

    puzzleBarrier = {}
        if testingMap.layers["Puzzlelock"] then
            for i, bar in pairs(testingMap.layers["Puzzlelock"].objects) do
                local barr = world:newRectangleCollider(bar.x, bar.y, bar.width, bar.height)
                barr:setType('static')
                
                table.insert(puzzleBarrier, barr)
            end
        end

        if saveLoad == true then
            print(saveLoad)
            if firstLoad == false then
                player.load(transition.coordx,transition.coordy)
            else
                flashlight.load()
                gengar.load()
                rock.loadSave()
                rock.load(rock.x,rock.y)
                battery1.load()
                battery2.load()
                battery3.load()
                waver.load()
                waver2.load()
                waver3.load()
                waver4.load()
            end
        else
        print(saveLoad)
        player.load(transition.coordx,transition.coordy)
        rock.load(rock.x,rock.y)
        end
end

function levelTwo:update(dt)
    player:update(dt)
    player.anim:update(dt)

    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:update(dt)
    end

    -- Computers and their waves
    if distanceBetweenSprites(player.x, player.y, 55, 80, 64, 164, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver)
        end
    end

    if distanceBetweenSprites(player.x, player.y, 55, 80, 1527.6566, 176.625, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver2)
        end
    end

    if distanceBetweenSprites(player.x, player.y, 55, 80, 1263, 1425, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver3)
        end
    end

    if distanceBetweenSprites(player.x, player.y, 55, 80, 98, 1449, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver4)
        end
    end

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)
   rock.update(dt)
   world:update(dt)
   if computer1 == 2 and computer2 == 3 and computer3 == 4 and computer4 == 1 then
        for i, barrier in ipairs(puzzleBarrier) do
            barrier:setCollisionClass('Ignore')
        end
   end
   shaders:update(dt)
end

function levelTwo:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["lava"])
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["items"])
        testingMap:drawLayer(testingMap.layers["walls"])
        if computer1 == 2 and computer2 == 3 and computer3 == 4 and computer4 == 1 then
        else
            testingMap:drawLayer(testingMap.layers["puzzlelock"])
        end

        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()
        world:draw()
        gengar.draw("levelOne")
        flashlight.draw("levelOne")
        rock.draw("levelOne")

        love.graphics.setColor(255,255,255,255)
    camera:detach()

    love.graphics.reset()

    DRAW_HUD()
    love.graphics.print(computer1, 100, 60)
    love.graphics.print(computer2, 100, 80)
    love.graphics.print(computer3, 100, 100)
    love.graphics.print(computer4, 100, 120)

    love.graphics.print(player.x, 100, 10)
    love.graphics.print(player.y, 100, 30)
end