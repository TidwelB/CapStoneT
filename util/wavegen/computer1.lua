local sine = require('util.wavegen.sinewave')
local saw = require('util.wavegen.sawwave')
local square = require('util.wavegen.squarewave')
local triangle = require('util.wavegen.trianglewave')
local wave

function computer1:compute()
    wave = sine

    wave.draw()
end

function computer1:update(dt)

end

function computer1:switch()
    if love.keypressed(arrowkey) and wave == sine then
        wave = saw
    end
    if love.keypressed(arrowkey) and wave == saw then
        wave = square
    end
    if love.keypressed(arrowkey) and wave == square then
        wave = triangle
    end
    if love.keypressed(arrowkey) and wave == triangle then
        wave = sine
    end
end