shaders = {}

-- NOTE: These shaders are written using GLSL for Love2D

--windowWidth, windowHeight = love.window.getMode()


function shaders:window()
    windowWidth = game.width
    windowHeight = game.height
end

scale = 100

shaders.flashlight = false
-- Hole-punch light source
shaders.simpleLight = love.graphics.newShader[[

    extern number originX = 0;
    extern number originY = 0;
    number radius = 100;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - originX, 2) + pow(screen_coords.y - originY, 2), 0.5);
        if (distance < radius) {
            return vec4(0, 0, 0, 0);
        }
        else {
            return vec4(0, 0, 0, 1);
        } 
    }
]]

-- Faded light source
shaders.trueLight = love.graphics.newShader[[
    extern number originX = 0;
    extern number originY = 0;
    number radius = 450;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - originX, 2) + pow(screen_coords.y - originY, 2), 0.5);
        number alpha = distance / radius;
        return vec4(0, 0, 0, alpha);
    }
]]

-- White damage flash
shaders.whiteout = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        vec4 pixel = Texel(texture, texture_coords);
        if (pixel.a == 1) {
            return vec4(1, 1, 1, 1);
        } else {
            return vec4(0, 0, 0, 0);
        }
    }
]]

function shaders:update(dt)
    shaders:window()

    if (shaders.flashlight == false) then

        local px = 400
        local py = 250

        -- Get width/height of background
        local mapW = testingMap.width * testingMap.tilewidth
        local mapH = testingMap.height * testingMap.tileheight

        local lightX = (windowWidth/2)
        local lightY = (windowHeight/2)

        shaders.simpleLight:send("originX", lightX)
        shaders.simpleLight:send("originY", lightY)
        shaders.trueLight:send("originX", lightX)
        shaders.trueLight:send("originY", lightY)



    else

        if (shaders.flashlight == true) then

        local px = 400
        local py = 250

        -- Get width/height of background
        local mapW = testingMap.width * testingMap.tilewidth
        local mapH = testingMap.height * testingMap.tileheight

        local lightX = love.mouse.getX()
        local lightY = love.mouse.getY()

        shaders.simpleLight:send("originX", lightX)
        shaders.simpleLight:send("originY", lightY)
        shaders.trueLight:send("originX", lightX)
        shaders.trueLight:send("originY", lightY)
        end
    end

end