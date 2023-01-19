Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'

-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")

SCP = {}
    SCP.width = 5
    SCP.height = 5
    SCP.speed = 200
    SCP.friction = 7.5
    SCP.size = 65



function SCP.spawn(x,y)
    table.insert(SCP, {x = x, y=y, xvel=0,yvel=0, health = 2, width = 2, height = 2})
end

function SCP.load()
    SCP.collider = world:newBSGRectangleCollider(400, 200, 65, 65, 14)
    SCP.collider:setFixedRotation(true)
    SCP.colX = 300
    SCP.colY = 200
    SCP.timer = 0
    SCP.colxvel = 0
    SCP.colyvel = 0
    SCP.x = 0
    SCP.y = 0
    SCP.lastx = 0
    SCP.lasty = 0
end

function SCP.draw()
        love.graphics.setColor(255,255,255)
        love.graphics.rectangle('fill',SCP.colX,SCP.colY,SCP.size,SCP.size)
end




function SCP.colAI(dt)

    SCP.timer = SCP.timer +1
    SCP.distance = ((player.x - SCP.collider:getX())^2 + (player.y - SCP.collider:getY())^2)^(1/2)
    SCP.xdist = ((player.x - SCP.collider:getX())^2)^(1/2)
    SCP.ydist = ((player.y - SCP.collider:getY())^2)^(1/2)
    SCP.xvect = (player.x - SCP.collider:getX()) / SCP.xdist
    SCP.yvect = (player.y - SCP.collider:getY()) / SCP.ydist
--snap out of player view
    if SCP.distance > 700 then
        SCP.collider:setPosition(50+((player.x + SCP.colX)/2), -(50+(-player.y + -SCP.colY)/2))
    end
--snap back to player
    if SCP.distance > 1000 then
        SCP.collider:setPosition((player.x), ((player.y)))
    end
--check distance to player
        if SCP.distance > 150 and SCP.distance < 700 then
        --check SCP right
            if player.x > SCP.collider:getX() then
                SCP.colxvel = SCP.speed
                --SCP.anim = SCP.animations.right
            end
        --check SCP left
            if player.x < SCP.collider:getX() then
                SCP.colxvel = -SCP.speed
                --SCP.anim = SCP.animations.left
            end
        --check SCP below
            if player.y > SCP.collider:getY() + 20 then
                SCP.colyvel = SCP.speed
                --SCP.anim = SCP.animations.left
            end
        --check SCP above
            if player.y < SCP.collider:getY() -20 then
                SCP.colyvel = -SCP.speed
                --SCP.anim = SCP.animations.right
            end
            if SCP.colxvel < 0 and SCP.xdist > 5 then
                SCP.anim = SCP.animations.left
        end
        if SCP.colxvel > 0 and SCP.xdist > 5 then
            SCP.anim = SCP.animations.right  
    end

        else
            if (SCP.timer%5 == 0) then
            SCP.colxvel = math.random(-100,100)
            SCP.colyvel = math.random(-100,100)

            if (math.random(0,100) == 19) then
                if SCP.anim == SCP.animations.idleR then
                SCP.anim = SCP.animations.idleL
                else
                    SCP.anim = SCP.animations.idleR
                end
            end
            SCP.collision()
            end
        end

        SCP.colX = SCP.colX + SCP.colxvel *dt
        SCP.colY = SCP.colY + SCP.colyvel *dt
        SCP.colxvel = SCP.colxvel * (1-math.min(dt*SCP.friction,1))
        SCP.colyvel = SCP.colyvel * (1-math.min(dt*SCP.friction,1))

        SCP.collider:setLinearVelocity(SCP.colxvel*(SCP.distance/150), SCP.colyvel*(SCP.distance/150))

end

function SCP.collision()
    if SCP.xdist < 68 then
        if SCP.ydist < 35 then
        SCP.colxvel = player.xvel
        Sounds.collision:play()
        end
    end
    if SCP.ydist < 90 then
        if SCP.xdist < 35 then
        SCP.colyvel = player.yvel
        Sounds.collision:play()
        end
    end
end

function SCP.pathing()

end


function SCP.colliderMatching(dt)
    SCP.x = SCP.collider:getX() -35
    SCP.y = SCP.collider:getY() - 20
end

function SCP.grow(dt)
    SCP.size = SCP.size + .1
    SCP.colX = SCP.colX -.1
    SCP.colY = SCP.colY + .1
end

 function DRAW_SCP()
     SCP.draw()
end

function UPDATE_SCP(dt)
    SCP.grow()
end