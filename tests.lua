
local testing = require("testing")
local assert = testing.assert
local register = testing.register

function Square(n)
    return n*n
end
function Test_sounds_not_nil()
    assert.not_nil(Sounds)
end
function Test_table_not_nil()
    assert.not_nil(table)
end
function Test_music_not_nil()
    assert.not_nil(Music)
end
function Test_walls_not_nil()
    assert.not_nil(walls)
end
testing.register("square 3", function()
    assert.equal(9, Square(3))
end)

-- function Test_speed_on_shift()
--     -- assume the player object exists and has a property "speed"
--     local isSprinting = isSprinting

--     -- assume the shift key press is detected and stored in a variable "shift_pressed"
--     if (love.keyboard.isDown('lshift') and love.keyboard.isDown("d") or love.keyboard.isDown("w") or love.keyboard.isDown("a") or love.keyboard.isDown("d")) or (love.keyboard.isDown('rshift') and love.keyboard.isDown("d") or love.keyboard.isDown("w") or love.keyboard.isDown("a") or love.keyboard.isDown("d")) then
--         assert.truthy(isSprinting)
--     else
--         assert.not_truthy(isSprinting)
--     end
-- end

function Test_idle()
    local xvel = player.xvel
    local yvel = player.yvel
    assert.truthy(xvel == 0)
    assert.truthy(yvel == 0 )
end
local function test_player_health_heartbeat_anim_draw()
    -- assume the player object exists and has a property "health"
    local health = player.health
    if health <= 0 or health >=0 then
        if health <=0 then
        error("player health is less than or equal to 0")
        else
        error("player health is greater than 100")
        end
      end
    if health > player.max_health / 2 then
        assert.not_nil(heartbeat.anim)
        assert.not_nil(heartbeat.spritesheet)
        heartbeat.anim:draw(heartbeat.spritesheet, 30, 30, nil, 3, nil, 9, 9)
    else if health <= player.max_health / 2 then
        assert.not_nil(heartbeat.anim)
        assert.not_nil(heartbeat.spritesheet)
        heartbeat.anim:draw(heartbeat.spritesheet, 30, 30, nil, 3, nil, 9, 9)
    else if (health <= player.max_health / 4) and (health > 0) then
        assert.not_nil(heartbeat.anim)
        assert.not_nil(heartbeat.spritesheet)
        heartbeat.anim:draw(heartbeat.spritesheet, 30, 30, nil, 3, nil, 9, 9)
    end
    end
    end
end



testing.register("square 5", function()
    assert.equal(25, Square(5)) -- Oops!
end)
testing.register("test_sounds_not_nil", Test_sounds_not_nil)
testing.register("test_music_not_nil", Test_music_not_nil)
testing.register("test_table_not_nil", Test_table_not_nil)
testing.register("test_walls_not_nil", Test_walls_not_nil)
testing.register("test_Idle", Test_idle)
testing.register("test_player_health_heartbeat_anim_draw", test_player_health_heartbeat_anim_draw)
-- testing.register("test_speed_on_shift", Test_speed_on_shift)