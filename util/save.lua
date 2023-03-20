
-- Gamestate library
local json = require("libraries.dkjson")
Gamestate = require 'libraries.gamestate'
save = {}
save = Gamestate.new()


local buttons = {}
BUTTON_HEIGHT = 64
font = nil
--losebackground = love.graphics.newImage("screens/lose.png")
local function newButton(text,fn)
    return{
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

if love.keyboard.isDown("escape") then
    Gamestate.push(menu)
end

function save:enter(from)
    
  --  img = love.graphics.newImage("screens/lose.png")
    --img:setWrap("repeat", "repeat")
    --quad = love.graphics.newQuad( 0,0, 800,600, 800,720)
    self.from = from
    
    --pause.load()
   -- love.graphics.clear()
    --love.graphics.reset()
   -- love.window.setMode(1024,1024)
    --todo
    --player.load()

end



--function pause:update(dt)
  --  pause.update(dt)
--end

local folder_path = "Desktop/Remedy" -- Replace this with the path to your folder
filepath = love.filesystem.getRealDirectory('/')

print(filepath)
-- print("printing filepath")
-- print(filepath)
-- Get the list of files in the folder
--local path = os.getenv("HOME") .. "/Desktop/Remedy/"
local files = {}
firstLoad = true
local op = love.system.getOS()
if op == "Windows" then
    filepath = string.gsub(filepath, "/", "\\")
    print(filepath)
    --local path = os.getenv("HOME") .. "\\Desktop\\Remedy\\"
   --local thing = os.getenv("HOMEDRIVE")
    --local penis = os.getenv("HOMEPATH")
    --print(thing)
   -- print(penis)
   -- local path = thing .. penis .. "\\Desktop\\Remedy\\"
    --local path = "C:\\Users\\18035\\Desktop\\Remedy\\"
print("hee")
    for file in io.popen("dir /B " .. filepath .. "\\".."*.json"):lines() do 
        print("woodoodod")
        print(file)
        local file_name = file
        file = filepath .. "\\"..file
        print(file)
        table.insert(files, file)
        file_name = file_name:gsub("[/%[%]%(%){}%+%-*%%^%$%?%.\\]%f[%a]json%f[%A]", "")
        --local file_name = file
        table.insert(buttons, newButton(file_name, function() 
            --Read and parse the JSON file
            files = io.open(file, "r")
            data_str = files:read("*all")
            data = json.decode(data_str)
            files:close()
            -- Do something with the data, e.g. set player coordinates
           
            -- player.x = data.position.x
            -- player.y = data.position.y
            print(data.position.x)
            print(data.position.y)

            inventory = data.inventory
            chest = data.chestInventory
            saveLoad = true

            if data.level == "runGame" then
                level = runGame
            elseif data.level == "levelOne" then
                shaders:window()
                level = runLevelOne
            elseif data.level == "levelTwo" then
                level = runLevelTwo
            elseif data.level == "levelThree" then
                level = runLevelThree
            end
            Gamestate.switch(level)
            player.load(data.position.x,data.position.y)
            firstLoad = false
        end))
    end


else
    --local path = os.getenv("HOME") .. "/Desktop/Remedy/"
    for file in io.popen("ls " .. filepath .. "/".."*.json"):lines() do 
        print(file)
        table.insert(files, file)
        local file_name = string.match(file,".+/([^/]+)$")
        print(filename)
        table.insert(buttons, newButton(file_name, function() 
            -- Read and parse the JSON file
            files = io.open(file, "r")
            data_str = files:read("*all")
            data = json.decode(data_str)
            files:close()
            -- Do something with the data, e.g. set player coordinates
            saveLoad = true
            if data.level == "runGame" then
                level = runGame
            elseif data.level == "levelOne" then
                shaders:window()
                level = runLevelOne
            elseif data.level == "levelTwo" then
                level = runLevelTwo
            elseif data.level == "levelThree" then
                level = runLevelThree
            end
            Gamestate.switch(level)
            player.x = data.position.x
            player.y = data.position.y
            inventory = data.inventory
            chest = data.chestInventory
            player.load(data.position.x,data.position.y)
            firstLoad = false
            --player.anim:draw(player.spriteSheet, data.position.x, data.position.y, nil, 5, nil, 6, 6)
        end))
    end

end




--local file_list = io.popen('ls *.json'):read("*all")
    

font = love.graphics.newFont(32)
function save:draw()
    love.graphics.reset()
   -- local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    --love.graphics.draw(losebackground, 0, 0, 0, screenWidth / losebackground:getWidth(), screenHeight / losebackground:getHeight())
    --love.graphics.draw(background, 0, 0, 0, love.graphics.getWidth() / background:getWidth(), love.graphics.getHeight() / background:getHeight())
    --love.graphics.draw(img, quad, 0,0, 0, 1,1)
   --love.graphics.reset()
    --self.from:draw()
    --font = love.graphics.newFont(32)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local buttonwidth = ww * (1/3)
    local margin = 16
    local cursor_y = 0
    local total = (BUTTON_HEIGHT+margin) * #buttons
    --love.graphics.printf('SETTINGS',0,wh/2,ww,'center')
    for i, buttons in ipairs(buttons) do
        buttons.last = buttons.now
        --love.graphics.setColor(255,255,255,1)
        local x = (ww*.5)-(buttonwidth*.5)
        local y = (wh * .5)-(total * .5)+cursor_y
        local color = {.8,.4,.5,1}
        local mousex, mousey = love.mouse.getPosition()
        local highlight = mousex > x and mousex < x + buttonwidth and mousey > y and mousey < y + BUTTON_HEIGHT
        if highlight then
            color  = {.8,.8,.9,1}
        end
        buttons.now = love.mouse.isDown(1)
        if buttons.now and not buttons.last and highlight then
            buttons.fn()
        end

        love.graphics.setColor((color))
        love.graphics.rectangle("fill",(ww*.5)-(buttonwidth*.5),(wh * .5)-(total * .5)+cursor_y,buttonwidth,BUTTON_HEIGHT)
        love.graphics.setColor(0,0,0,1)
        local textwidth = font:getWidth(buttons.text)
        local textHeight = font:getHeight(buttons.text)
        love.graphics.print(buttons.text,font,(ww*.5)-textwidth*.5,y+textHeight*.5)
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end

    love.graphics.reset()

   -- if love.keyboard.isDown('s') then
     --   Gamestate.pop()
       -- love.graphics.reset()
        --Gamestate.push(settings)
        --settings.load()
    if love.keyboard.isDown('escape') then
        love.timer.sleep(.15)
        Gamestate.pop()
    end
end

 function save.load()

   -- losebackground = love.graphics.newImage("screens/lose.jpg")
--     --Gamestate.switch(pause)

end


function save:update()
    if love.keyboard.isScancodeDown('p') then
        love.timer.sleep(.15)
        return Gamestate.pop()
    end
end





