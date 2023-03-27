
require("util.wavegen.waver")
require("util.wavegen.waver2")
require("util.wavegen.waver3")
require("util.wavegen.waver4")
save_file_menu = {}


function save_file_menu:enter(from)
    self.from = from
    self.filename = ""
end

function save_file_menu:update(dt)
    -- nothing to update
end

function save_file_menu:draw()
    love.graphics.reset()
    if files[5] ~= nil then
        local temp = files[5]
        temp = temp:gsub(filepath, ""):gsub("%.json", ""):gsub("/", ""):gsub("\\","")
        love.graphics.printf("WARNING: There is already 5 saves present so by creating a new save you will be overwriting the oldest save", 0, love.graphics.getHeight()/2 - 125, love.graphics.getWidth(), "center")
        love.graphics.printf("The file that is being overwritten is: " .. temp, 0, love.graphics.getHeight()/2 -100, love.graphics.getWidth(), "center")
        -- need to get rid of extra stuff for the file path here so its just the name not all the extra
    end
    --self.from:draw()
    love.graphics.printf("Enter a filename:", 0, love.graphics.getHeight()/2 - 64, love.graphics.getWidth(), "center")
    love.graphics.printf(self.filename, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
    if love.keyboard.isDown("escape") then
        love.timer.sleep(.3)
        --Sounds.music:pause()
        Gamestate.pop()
    end
    
    --love.graphics.reset()
end

function save_file_menu:textinput(t)
    -- append typed characters to the filename
    self.filename = self.filename .. t
end

function save_file_menu:keypressed(key)
    if key == "backspace" then
        -- remove the last character from the filename
        self.filename = self.filename:sub(1, #self.filename-1)
    elseif key == "return" then
       -- local currentState = Gamestate.current()s
        local musvolume = Music.music:getVolume()
        local souvolume = Sounds.collision:getVolume()
        local date = os.time()
        local dateString = os.date("%Y-%m-%d %H:%M:%S", date)
        -- save the game to a file with the specified filename
        local playerData = {
            position = {x = player.x,y = player.y},
            inventory = saveInventory,
            level = room,
            mvol = musvolume,
            svol = souvolume,
            rockpos = {x = rock.x, y = rock.y,room = rock.room},
            flashlightpos = {x = flashlight.x, y = flashlight.y, room = flashlight.room},
            gengarpos = {x = gengar.x, y = gengar.y, room = gengar.room},
            battery1 = {x = battery1.x, y = battery1.y, room = battery1.room},
            battery2 = {x = battery2.x, y = battery2.y, room = battery2.room},
            battery3 = {x = battery3.x, y = battery3.y, room = battery3.room},
            book = {x = book.x,y = book.y, room = book.room},
            ball = {x = ball.x,y = ball.y, room = ball.room},
             two = levelTwo.done,
             three = bluemon.done,
             wave1 = waver.wave,
             wave2 = waver2.wave2,
             wave3 = waver3.wave3,
             wave4 = waver4.wave4,
            chargecable = {x = chargecable.x, y = chargecable.y, room = chargecable.room},
            chestInventory = chestInventory,
            date = dateString
            --item positions for puzzle 3
        }
        
        write_to_json_file(self.filename .. ".json", playerData)
        Gamestate.pop()
    end
end


