Gamestate = require 'libraries.gamestate'
story = {}
story = Gamestate.new()


positions = {
    {50, 50},
    {50, 100},
    {50, 150},
    {50, 200}
}
text = {
    "This will be the story introduction",
    "Someone can write this if they see fit",
    "Important things to write would be that they need to talk to the scientist once the game starts",
    "As well as that to leave this screen they need to hit enter"
}
charIndex = {0, 0, 0, 0}
lineIndex = 1
linePrinted = {false, false, false, false}
timeElapsed = 0
delay = 0.02
isFinished = false


  function story.load()
    love.graphics.setFont(love.graphics.newFont(20))
    positions = {
        {50, 50},
        {50, 100},
        {50, 150},
        {50, 200}
    }
    text = {
        "This will be the story introduction",
        "Someone can write this if they see fit",
        "Important things to write would be that they need to talk to the scientist once the game starts",
        "As well as that to leave this screen they need to hit enter"
    }
    charIndex = {0, 0, 0, 0}
    lineIndex = 1
    linePrinted = {false, false, false, false}
    timeElapsed = 0
    delay = 0.02
    isFinished = false
end

function story:update(dt)
    if isFinished then return end

    timeElapsed = timeElapsed + dt
    if timeElapsed > delay then
        timeElapsed = timeElapsed - delay
        charIndex[lineIndex] = charIndex[lineIndex] + 1
        if charIndex[lineIndex] > #text[lineIndex] then
            linePrinted[lineIndex] = true
        end
    end
    if love.keyboard.isDown('return') then
        love.timer.sleep(.15)
        Gamestate.switch(runGame)
    end
end

function story:draw()
    for i = 1, #text do
        if i < lineIndex then
            love.graphics.print(text[i], positions[i][1], positions[i][2])
        elseif i == lineIndex then
            if linePrinted[i] then
                love.graphics.print(text[i], positions[i][1], positions[i][2])
            else
                love.graphics.print(string.sub(text[i], 1, charIndex[i]), positions[i][1], positions[i][2])
            end
        else
            love.graphics.print("Press 'return' to continue", positions[#text][1], positions[#text][2] + 50)
        end
    end
    if linePrinted[lineIndex] then
        charIndex[lineIndex] = 0
        lineIndex = lineIndex + 1
        if lineIndex > #text then
            Gamestate.switch(runGame)
            end
        end
    end

