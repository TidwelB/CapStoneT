-- Gamestate library
Gamestate = require 'libraries.gamestate'

game = {}
menu = {}

require("enemy")
require("player")
require("scientist")
require("shaders")
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.rock")
require("util.items.battery1")
require("util.items.battery2")
require("util.transition")
Moan = require 'libraries/Moan/Moan'
require("SCP076")
local testing = require("testing.testing")
range = 100


function game:enter()
    room = "runGame"
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
    camera:zoom(1)
    -- loads in the map
    testingMap = sti('maps/mainlobby.lua')

    -- draws the window size
    world = wf.newWorld(0, 0)
    love.window.setTitle("SCP: FALLEN")
    love.window.setMode(1920, 1080, {resizable=true, vsync=0, minwidth=400, minheight=300})

    enemy.spawn(500,500)
    enemy.load()
    scientist.spawn(100,800)

    --  Walls table: 
    --          intializes the hitboxes for the map 
    --          whether that be the walls, the green stuff, etc...
    world:addCollisionClass('Solid')
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})
    rock.load(rock.x,rock.y)


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
    end
    --player.load(data.position.x,data.position.y)
else
print(saveLoad)
player.load(transition.coordx,transition.coordy)


end
            
end


function game:update(dt)
    player:update(dt)
    player.anim:update(dt)
    scientist:update(dt)
    scientist.anim:update(dt)
    if (player.health > (player.max_health / 2)) then
        heartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 2) and player.health > (player.max_health / 4)) then
        yellowheartbeat.anim:update(dt)
    elseif (player.health <= (player.max_health / 4)) then
        redheartbeat.anim:update(dt)
    end

   enemy.anim:update(dt)
    --timer = timer + dt
    UPDATE_ENEMY(dt)
    

    game.height = love.graphics.getHeight()
    game.width = love.graphics.getWidth()

   -- Moves the camera according to the players movements
   camera:lookAt(player.x, player.y)
    rock.update(dt)
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


        -- if checkInventory(inventory, "gengar") == false then
        -- love.graphics.draw(gengar.spritesheet,gengar.x,gengar.y)
        -- end
        gengar.draw("runGame")
        flashlight.draw("runGame")
        rock.draw("runGame")
        battery1.draw("runGame")
        battery2.draw("runGame")
        battery3.draw("runGame")
        -- if checkInventory(inventory, "flashlight") == false then
        --     love.graphics.draw(flashlight.spritesheet,flashlight.x,flashlight.y,0,flashlight.scale,flashlight.scale)
        -- end

        if Gamestate.current() == pause then 
        DRAW_SCP(SCP076, player.x, player.y, 0)
        else
        DRAW_SCP(SCP076, player.x, player.y, love.timer.getDelta())
        end

        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, nil, 6, 6)
        scientist.anim:draw(scientist.spriteSheet,scientist.x,scientist.y,nil,5,nil,6,6)
        --enemy.draw()
        DRAW_ENEMY()
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
        world:draw()


    camera:detach()
        Moan.draw()
    love.graphics.reset()

    DRAW_HUD()
    --DRAW_ENEMY()
    love.graphics.print(player.x, 100, 10)
    love.graphics.print(player.y, 100, 30)

    love.graphics.print(enemy.x, 100, 50)
    love.graphics.print(enemy.collider:getX(), 100, 70)

    --testing.run()
end