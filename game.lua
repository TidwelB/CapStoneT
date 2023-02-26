-- Gamestate library
Gamestate = require 'libraries.gamestate'

game = {}
menu = {}

-- Required libraries
require("enemy")
require("player")
require("scientist")
require("shaders")
require("util.items.gengar")
require("util.items.flashlight")
require("util.items.rock")
require("util.items.battery1")
require("util.items.battery2")
require("util.items.book")
require("util.transition")

Moan = require 'libraries/Moan/Moan'

require("SCP076")

local testing = require("testing.testing")
range = 100

-- Starts the Main Lobby room
-- and intializes all of the features.
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

    world:addCollisionClass('Solid')

    -- Code that lets the player walk
    -- into the transition hitbox and it analyze and 
    -- switch gamestates
    world:addCollisionClass('Ghost', {ignores = {'Solid'}})

    rock.load(rock.x,rock.y)

    --  Walls table: 
    --         intializes the hitboxes for the map 
    --         whether that be the walls, the green stuff, etc...
    walls = {}
        if testingMap.layers["Walls"] then
            for i, box in pairs(testingMap.layers["Walls"].objects) do
                local wall = world:newRectangleCollider(box.x, box.y, box.width, box.height)
                wall:setType('static')
                table.insert(walls, wall)
            end
        end

    --  Transitions table: 
    --         intializes the transition hitbox for switching maps
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
            book.load()
        end
    else
    print(saveLoad)
    player.load(transition.coordx,transition.coordy)
    end 
end

-- Updates the game and makes sure all of
-- the necessary features are also updating
-- @param dt <- Updates every frame on delta time
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
    UPDATE_ENEMY(dt)
    
    game.height = love.graphics.getHeight()
    game.width = love.graphics.getWidth()

   -- Moves the camera according to the players movements
    camera:lookAt(player.x, player.y)

    rock.update(dt)
    world:update(dt)
end




function game:draw()
    -- Tells the game where to start looking through the camera POV
    camera:attach()
        -- Draws all the cosmetic only layers
        testingMap:drawLayer(testingMap.layers["floor"])
        testingMap:drawLayer(testingMap.layers["barrier"])
        testingMap:drawLayer(testingMap.layers["water"])
        testingMap:drawLayer(testingMap.layers["objects"])
        testingMap:drawLayer(testingMap.layers["chairs"])

        gengar.draw("runGame")
        flashlight.draw("runGame")
        rock.draw("runGame")
        battery1.draw("runGame")
        battery2.draw("runGame")
        battery3.draw("runGame")

        -- Animates the player and the scientist
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, nil, 6, 6)
        scientist.anim:draw(scientist.spriteSheet,scientist.x,scientist.y,nil,5,nil,6,6)
        
        DRAW_ENEMY()

        -- This feature draws the hitboxes of the game
        -- world:draw()

    -- Lines after this will not be focused on the player
    camera:detach()

    -- Draws the dialouge boxes
    Moan.draw()

    love.graphics.reset()

    -- Draws the player HUD
    DRAW_HUD()
end