function love.load()
    wf = require 'libraries/windfield'
    sti = require 'libraries/sti'

    gameEnd = sti( 'maps/mrantDeath.lua' )

    world = wf.newWorld(0, 0)
    love.window.setMode(400, 400)

    player = {}
    player.collider = world:newBSGRectangleCollider(0, 0, 45, 35, 20)
    player.collider:setFixedRotation(true)
    player.speed = 250
    player.x = 0
    player.y = 0
    player.sprite = love.graphics.newImage('sprites/mrant.png')

    world:addCollisionClass('SolidWall')
    world:addCollisionClass('Ghost', {ignores = {'SolidWall'}})

    background = love.graphics.newImage('sprites/ground.png')

    local topWall = world:newRectangleCollider(0, -400, 400, 400)
    topWall:setType('static')
    topWall:setCollisionClass('SolidWall')

    local rightWall = world:newRectangleCollider(400, 0, 400, 400)
    rightWall:setType('static')
    rightWall:setCollisionClass('SolidWall')

    local botWall = world:newRectangleCollider(0, 400, 400, 400)
    botWall:setType('static')
    botWall:setCollisionClass('SolidWall')

    local leftWall = world:newRectangleCollider(-400, 0, 400, 400)
    leftWall:setType('static')
    leftWall:setCollisionClass('SolidWall')

    timer = 0 
end

function love.update(dt)
    timer = timer + dt

    local vx = 0
    local vy = 0

   if love.keyboard.isDown("d") then
       vx = player.speed
   end
   if love.keyboard.isDown("a") then
       vx = player.speed * -1
   end
   if love.keyboard.isDown("s") then
       vy = player.speed
   end
   if love.keyboard.isDown("w") then
       vy = player.speed * -1
   end

   player.collider:setLinearVelocity(vx, vy)

   world:update(dt)

   player.x = player.collider:getX() - 18
   player.y = player.collider:getY() - 15
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(player.sprite, player.x, player.y)
    love.graphics.draw(enemy.spriteRight, enemy.x, enemy.y)
    world:draw()
end