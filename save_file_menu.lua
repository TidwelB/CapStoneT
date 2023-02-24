
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
    --self.from:draw()

    love.graphics.printf("Enter a filename:", 0, love.graphics.getHeight()/2 - 64, love.graphics.getWidth(), "center")
    love.graphics.printf(self.filename, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")

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
        -- save the game to a file with the specified filename
        local playerData = {
            position = {x = player.x,y = player.y},
            inventory = saveInventory,
            level = room,
            mvol = musvolume,
            svol = souvolume

        }
        
        write_to_json_file(self.filename .. ".json", playerData)
        Gamestate.pop()
    end
end
