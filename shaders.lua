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

    extern number playerX = 0;
    extern number playerY = 0;
    extern number mouseX = 0;
    extern number mouseY = 0;
    extern bool flashlight = true;
    number radius = 100;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - playerX, 2) + pow(screen_coords.y - playerY, 2), 0.5);
        number mousedistance = pow(pow(screen_coords.x - mouseX, 2) + pow(screen_coords.y - mouseY, 2), 0.5);
        if (flashlight == false){
            if (distance < radius) {
                return vec4(0, 0, 0, 0);
            }
            else {
                return vec4(0, 0, 0, 1);
            } 
        }
        else if (flashlight == true) {
            for (int i = -100; i < 100; i++) {
                //for (int j; j < 100; j++){

                
            
            if (  (screen_coords.x - mouseX)/(playerX - mouseX) == (screen_coords.y - mouseY)/(playerY - mouseY+i) ) {
                if ((screen_coords.x - mouseX)/(playerX - mouseX) < .5) {
                    return vec4(0, 0, 0, 0);
                }
                //}  
            }
        }


            if (mousedistance<radius) {
                return vec4(0, 0, 0, 0);
            }
            if (distance < radius) {
            return vec4(0, 0, 0, 0);
            } 
        else {
            return vec4(0, 0, 0, 1);
}
}
    }
]]

-- Faded light source
shaders.trueLight = love.graphics.newShader[[
    extern number originX = 0;
    extern number originY = 0;
    extern number  mouseX = 0;
    extern number mouseY = 0;
    extern bool flashlight = false;
    number radius = 300;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
        number distance = pow(pow(screen_coords.x - originX, 2) + pow(screen_coords.y - originY, 2), 0.5);
        number mousedistance = pow(pow(screen_coords.x - mouseX, 2) + pow(screen_coords.y - mouseY, 2), 0.5);
        number alpha = distance / radius;
        if (flashlight == false) {
        if(distance < radius) {
            return vec4(0, 0, 0, alpha);   
        }
            else {
                return vec4(0, 0, 0, alpha);
            } 
        }
        else if (flashlight == true) {
            number mousealpha = mousedistance/radius;
            if (mousedistance<radius) {
                return vec4(0, 0, 0, mousealpha);
            }
            if (distance < (radius) / 4) {
                number smallalpha = distance / (radius/4);
                return vec4(0, 0, 0, smallalpha);
                }

        else {
            return vec4(0, 0, 0, 1);
}
        }
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

        shaders.simpleLight:send("playerX", lightX)
        shaders.simpleLight:send("playerY", lightY)
        shaders.trueLight:send("originX", lightX)
        shaders.trueLight:send("originY", lightY)
        shaders.simpleLight:send("flashlight", shaders.flashlight)
        shaders.trueLight:send("flashlight", shaders.flashlight)



    else

        if (shaders.flashlight == true) then

        local px = love.mouse.getX()
        local py = love.mouse.getY()

        -- Get width/height of background
        local mapW = testingMap.width * testingMap.tilewidth
        local mapH = testingMap.height * testingMap.tileheight

        local lightX = (windowWidth/2)
        local lightY = (windowHeight/2)

        shaders.trueLight:send("originX", lightX)
        shaders.trueLight:send("originY", lightY)
        shaders.trueLight:send("mouseX", px)
        shaders.trueLight:send("mouseY", py)
        shaders.trueLight:send("flashlight", shaders.flashlight)
        shaders.simpleLight:send("playerX", lightX)
        shaders.simpleLight:send("playerY", lightY)
        shaders.simpleLight:send("mouseX", px)
        shaders.simpleLight:send("mouseY", py)
        shaders.simpleLight:send("flashlight", shaders.flashlight)
        end
    end

end