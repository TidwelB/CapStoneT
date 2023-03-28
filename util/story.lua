Gamestate = require 'libraries.gamestate'
story = {}
story = Gamestate.new()


local positions = {
    {50, 50},
    {50, 100},
    {50, 150},
    {50, 200},
    {50, 250}
}
local text = {
    "This will be the story introduction",
    "Someone can write this if they see fit",
    "Important things to write would be that they need to talk to the scientist once the game starts",
    "As well as that to leave this screen they need to hit enter",
    "Press ENTER to continue to the game"
    --Whenever you add a new line add a new 0 value to charIndex, a new false value to linePrinted, and a new position vector
}
local charIndex = {0, 0, 0, 0, 0}
local lineIndex = 1
local linePrinted = {false, false, false, false, false}
local timeElapsed = 0
local delay = 0.02
local gameState = "intro"


  function story.load()

end

function story:update(dt)
    if gameState == "intro" then
        timeElapsed = timeElapsed + dt
        if timeElapsed > delay then
            timeElapsed = timeElapsed - delay
            charIndex[lineIndex] = charIndex[lineIndex] + 1
            if charIndex[lineIndex] > #text[lineIndex] then
                linePrinted[lineIndex] = true
            end
        end
        if linePrinted[lineIndex] then
            charIndex[lineIndex] = 0
            lineIndex = lineIndex + 1
            if lineIndex > #text then
                gameState = "wait_for_input"
            end
        end
    elseif gameState == "wait_for_input" then
        if love.keyboard.isDown('return') then
            gameState = "next_screen"
        end
    end
    if love.keyboard.isDown('return') then
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
            break
        end
    end

end

