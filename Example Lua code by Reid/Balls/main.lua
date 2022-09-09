function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    color1 = 255;
    color2 = 0;
    color3 = 0;

    score = 0
    timer = 15;
    finished = 0

    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    gameFont = love.graphics.newFont(40)
end

function love.update(dt)
        timer = timer - dt
end

function love.draw()
    love.graphics.setColor(color1/255, color2/255, color3/255)
    love.graphics.circle("fill", target.x, target.y, target.radius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print(score, 0, 0)

    love.graphics.setColor(213,123,213)
    love.graphics.circle("line", love.mouse.getX(), love.mouse.getY(), 15)
    if timer <= finished then
        color1 = 0
        color2 = 0
        color3 = 0
      
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(gameFont)
        love.graphics.print("You destroyed: "..score.." balls\nIn 15 seconds!", 250, 100)

        if score <= 15 then
            love.graphics.print("YOU SUCK", 250, 200)
        elseif score > 15 and score <= 20 then
            love.graphics.print("You're okay at this", 250, 200)
        elseif score > 20 and score <= 35 then
            love.graphics.print("Dang you're pretty good", 250, 200)
        elseif score > 35 then
            love.graphics.print("Jeez you're way too good at this game man", 250, 200)
        end
        love.graphics.setColor(0, 0, 0)
    end
    love.graphics.print(timer, 100, 0)
end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 1

            color1 = love.math.random(25, 255)
            color2 = love.math.random(25, 255)
            color3 = love.math.random(25, 255)

            target.x = love.math.random(target.radius, width - target.radius)
            target.y = love.math.random(target.radius, height - target.radius)
        end
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end