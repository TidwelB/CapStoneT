
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
testing.register("square 3", function()
    assert.equal(9, Square(3))
end)

testing.register("square 5", function()
    assert.equal(25, Square(5)) -- Oops!
end)
testing.register("test_sounds_not_nil", Test_sounds_not_nil)
testing.register("test_music_not_nil", Test_music_not_nil)
testing.register("test_table_not_nil", Test_table_not_nil)