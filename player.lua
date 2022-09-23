player = {}


function player.load()

        player.collider = world:newBSGRectangleCollider(400, 250, 65, 100, 14)
        player.collider:setFixedRotation(true)
        player.x = 0
        player.y = 0
        player.speed = 250
        player.spriteSheet = love.graphics.newImage('sprites/guard_yellow_spritesheet.png')
        player.grid = anim8.newGrid( 16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

end
