function love.load()
    wf = require 'libraries/windfield'
    sti = require 'libraries/sti'
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    world = wf.newWorld(0, 0)
    love.window.setMode(1000, 1000)

    player = {}
    
    player.speed = 250
    player.x = 0
    player.y = 0
    player.speed = 2.5
    player.spriteSheet = love.graphics.newImage('sprites/loose-sprites.png')
    player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    player.animations.left = anim8.newAnimation( player.grid('1-4', 3), 0.2 )
    player.animations.right = anim8.newAnimation( player.grid('1-4', 7), 0.2 )
    player.animations.up = anim8.newAnimation( player.grid('1-4', 5), 0.2 )

    player.anim = player.animations.left

    background = love.graphics.newImage('sprites/ground.png')

    timer = 0 
end

function love.update(dt)
    timer = timer + dt

    local isMoving = false

   if love.keyboard.isDown("d") then
       player.x = player.x + player.speed
       player.anim = player.animations.right
       isMoving = true
   end
   if love.keyboard.isDown("a") then
       player.x = player.x - player.speed
       player.anim = player.animations.left
       isMoving = true
   end
   if love.keyboard.isDown("s") then
       player.y = player.y + player.speed
       player.anim = player.animations.down
       isMoving = true
   end
   if love.keyboard.isDown("w") then
       player.y = player.y - player.speed
       player.anim = player.animations.up
       isMoving = true
   end

   if (isMoving == false) then
        player.anim:gotoFrame(3)
   end

   player.anim:update(dt)

   world:update(dt)
   
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 10)
    world:draw()
end