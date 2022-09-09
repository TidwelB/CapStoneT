function LEnemy()
    player = {}
    player.collider = world:newBSGRectangleCollider(0, 0, 45, 35, 20)
    player.collider:setFixedRotation(true)
    player.speed = 250
    player.x = 0
    player.y = 0
    player.sprite = love.graphics.newImage('sprites/mrant.png')
end

function enemy(type)
    if type == "left" then
        --spawn left side enemy
    elseif type == "right" then
        --spawn right side enemy
    end
end