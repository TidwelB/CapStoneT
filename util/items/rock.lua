rock = {}
    rock.spritesheet = love.graphics.newImage("sprites/rock.png")
    rock.x = 400
    rock.y = 400
    rock.h = rock.spritesheet:getHeight()
    rock.w = rock.spritesheet:getWidth()
    --rock.collider = world:newBSGRectangleCollider(400, 400, rock.h, rock.w, 14)
    rock.room = "runGame"

function rock:load()
    if rock.collider == nil and rock.room == room then
    rock.collider = world:newBSGRectangleCollider(400, 400, rock.h, rock.w, 14)
    end
end

function rock:draw() 
    if checkInventory(inventory, "rock") == false then
    if rock.room == room then
    love.graphics.draw(rock.spritesheet,rock.x,rock.y)
    end
end
end

function rock.update(dt)
    if checkInventory(inventory, "rock") == false then
        rock.x = rock.collider:getX() 
        rock.y = rock.collider:getY() 
        love.graphics.draw(rock.spritesheet, rock.x, rock.y, rock.collider:getAngle(), 1, 1, rock.w/2, rock.h/2)
        local x, y = rock.collider:getLinearVelocity()
        local w = rock.collider:getAngularVelocity()
        if (math.random(0,range) == 1) then
            if x > 1 and y > 1 and w > 1 then
            x = x * 0.33
            y = y * 0.33
            w = w * 0.33
            else
            x = 0
            y = 0
            w = 0
            end
            range = range / 1.5
            if range < 10 then
                range = 100
            end
        end
        rock.collider:setAngularVelocity(w)
        rock.collider:setLinearVelocity(x, y)
    end
end