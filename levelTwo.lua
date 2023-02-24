-- Gamestate library

Gamestate = require 'libraries.gamestate'
levelTwo = Gamestate.new()
levelTwo = {}
walls = {}
require('util.wavegen.waver')
-- local computer2 = require('util.wavegen.computer2')
-- local computer3 = require('util.wavegen.computer3')
-- local computer4 = require('util.wavegen.computer4')
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



        if saveLoad == true then
            print(saveLoad)
        else
        print(saveLoad)
        player.load()
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

    if distanceBetweenSprites(player.x, player.y, 55, 80, 64, 164, 93.33, 48.00) < 150 then
        if love.keyboard.isDown("e") then
            Gamestate.push(waver)
        end
    end

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)

   world:update(dt)
   shaders:update(dt)
end

function levelTwo:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["lava"])
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["items"])
        testingMap:drawLayer(testingMap.layers["walls"])
        testingMap:drawLayer(testingMap.layers["puzzlelock"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()
        world:draw()


        love.graphics.setColor(255,255,255,255)
    camera:detach()

    love.graphics.reset()

    DRAW_HUD()

    love.graphics.print(player.x, 100, 10)
    love.graphics.print(player.y, 100, 30)
end