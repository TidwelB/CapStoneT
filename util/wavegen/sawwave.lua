local data = {} -- table to hold waveform data
local maxDataPoints = 200 -- maximum number of data points to store
local updateInterval = 0.1 -- time interval between new data points
local period = 1 -- time period of the waveform
local dutyCycle = 0.5 -- duty cycle of the waveform

function addDataPoint()
    -- Calculate the time since the start of the program
    local time = love.timer.getTime()
    
    -- Calculate the value of the waveform at the current time
    local t = time % period
    local value = t / period * 2 - 1
    
    -- Add the data point to the data table
    table.insert(data, value)
    
    -- Remove the oldest data point if the maximum number of data points has been reached
    if #data > maxDataPoints then
        table.remove(data, 1)
    end
end

function love.update(dt)
    -- Add a new data point at the specified time interval
    updateInterval = updateInterval - dt
    if updateInterval <= 0 then
        addDataPoint()
        updateInterval = period / maxDataPoints -- update the interval based on the waveform period and the number of data points
    end
end

function love.draw()
    love.graphics.clear(0.2, 0.2, 0.2) -- clear the screen with a dark gray color
    love.graphics.setColor(1, 1, 1) -- set the drawing color to white
    love.graphics.setLineWidth(1) -- set the line width to 1 pixel
    love.graphics.setLineStyle("smooth") -- set the line style to a smooth line with rounded corners
    
    -- Draw the waveform data points as a line
    for i = 2, #data do
        love.graphics.line(
            (i - 2) * love.graphics.getWidth() / (maxDataPoints - 1),
            (data[i - 1] + 1) * love.graphics.getHeight() / 2,
            (i - 1) * love.graphics.getWidth() / (maxDataPoints - 1),
            (data[i] + 1) * love.graphics.getHeight() / 2
        )
    end
end
