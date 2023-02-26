-- Gamestate library

Gamestate = require 'libraries.gamestate'
levelOne = {}
walls = {}
require('game')
require("util.transition")
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.rock")
require("util.items.battery1")
require("util.items.battery2")
require("util.items.battery3")
require("util.items.crate")
require("util.items.book")
require("scp106")

function levelOne:enter()
    room = "levelOne"
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
    testingMap = sti('maps/level1.lua')

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

    Sounds.boop = love.audio.newSource("sounds/boop.wav", "static")

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

        generator = world:newRectangleCollider(2480,135,70,20)
        generator:setType('static')
        generator:setCollisionClass('Solid')

        spawnCrate(1400,2600)
        spawnCrate(1400,3000)


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
                book.load()
            end 
        else
        print(saveLoad)
        player.load(transition.coordx, transition.coordy)
        end
        rock.load(rock.x,rock.y)
        --enemy.load()
        --SCP.load()
        
        
end

function levelOne:update(dt)
    
    player:update(dt)
    player.anim:update(dt)

    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:update(dt)
    end
    local batcount = 0
    if love.keyboard.isDown("e") and (checkInventory(inventory, "battery1") == true or checkInventory(inventory, "battery2") == true or checkInventory(inventory, "battery3") == true) then 
        if distanceBetweenSprites(player.x, player.y, 55, 80, 2480,135,70,20) < 150 then 
            -- need to remove from inventory then move on if battery count = 3 
            if checkInventory(inventory, "battery1") == true then
                Sounds.boop:play()
                battery1.x = 20000
                battery1.y = 0
                batcount = batcount + 1
            end
            if checkInventory(inventory, "battery2") == true then
                Sounds.boop:play()
                battery2.x = 20000
                battery2.y = 0
                batcount = batcount + 1
            end
            if checkInventory(inventory, "battery3") == true then 
                Sounds.boop:play()
                battery3.x = 20000
                battery3.y = 0
                batcount = batcount + 1
            end
        end
    end
    --enemy.anim:update(dt)
    --UPDATE_ENEMY(dt)
    --UPDATE_SCP(dt)

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)
   rock.update(dt)
   world:update(dt)
   shaders:update(dt)
   crates:update(dt)

end

function levelOne:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["walls"])
        testingMap:drawLayer(testingMap.layers["stuff"])
        testingMap:drawLayer(testingMap.layers["items"])
        --testingMap:drawLayer(testingMap.layers["bluepuzzlelock"])

       --enemy.draw()

        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()
        world:draw()
        crates.draw()
        battery1.draw("levelOne")
        battery2.draw("levelOne")
        battery3.draw("levelOne")
        gengar.draw("levelOne")
        flashlight.draw("levelOne")
        rock.draw("levelOne")
        book:draw("levelOne")
        chargecable.draw("levelOne")
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, nil, 8, 8)
        love.graphics.setColor(255,255,255,255)
        --love.graphics.rectangle('fill', 400,200,size,size,14)
        --DRAW_SCP()
       -- scp106.UPDATE_ENEMY()
        love.graphics.setShader(shaders.simpleLight)
        love.graphics.rectangle("fill", player.x -5000, player.y -5000, 10000, 10000)
        love.graphics.setShader()


        if love.keyboard.isDown("j") then
            table.insert(inventory,"Itemsssssss")
        end
    camera:detach()
    love.graphics.reset()
    DRAW_HUD()
    love.graphics.print(player.x, 100, 10)
    love.graphics.print(player.y, 100, 30)
end