Gamestate = require 'libraries.gamestate'
anim8 = require 'libraries/anim8'


-- makes stretch not blurry
love.graphics.setDefaultFilter("nearest", "nearest")

SCP076 = {}
    SCP076.spritesheet = love.graphics.newImage("sprites/SCP076.png")
    SCP076.x = 500
    SCP076.y = 800



function SCP076.spawn(x,y)
    table.insert(SCP076, {x = x, y=y})
end


function drawSCP076WithSize(SCP076, playerX, playerY, dt)
    local distance = math.sqrt((SCP076.x - playerX)^2 + (SCP076.y - playerY)^2)
    print(distance)
    local dist = distance/1000000
    local maxScale = .065
    local scale = math.min(maxScale,dist)
    local growthFactor = math.exp(-distance/100)
    growthFactor = math.min(growthFactor,1/10)
    SCP076.scale = SCP076.scale or scale
    print(SCP076.scale)
    SCP076.scale = SCP076.scale + growthFactor * dt
        
        -- Calculate the new width and height based on the original dimensions and the scaling factor
    local spriteWidth, spriteHeight = SCP076.spritesheet:getDimensions()
    local newWidth, newHeight = spriteWidth * SCP076.scale, spriteHeight * SCP076.scale
      
        -- Calculate the offset needed to maintain the center point of the PNG
    local xOffset = (newWidth - spriteWidth * SCP076.scale) / 2
    local yOffset = (newHeight - spriteHeight * SCP076.scale) / 2
      
        -- Draw the PNG using the origin parameter to maintain the center point
    love.graphics.draw(SCP076.spritesheet, SCP076.x + xOffset, SCP076.y + yOffset, 0, SCP076.scale, SCP076.scale, spriteWidth/2, spriteHeight/2)
    print(SCP076.scale)
    end

 function DRAW_SCP(SCP076, playerX, playerY, dt)
    drawSCP076WithSize(SCP076, playerX, playerY, dt)

end

function UPDATE_SCP(dt)
    --SCP.grow()
end