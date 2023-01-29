
local testing = require("testing")
local assert = testing.assert
local register = testing.register

local function square(n)
    return n*n
end
local function test_sounds_not_nil()
    assert.not_nil(Sounds)
end
local function test_table_not_nil()
    assert.not_nil(table)
end
local function test_music_not_nil()
    assert.not_nil(Music)
end
testing.register("square 3", function()
    assert.equal(9, square(3))
end)

testing.register("square 5", function()
    assert.equal(25, square(5)) -- Oops!
end)
