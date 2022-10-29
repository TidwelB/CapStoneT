transition = {}
Gamestate = require 'libraries.gamestate'

function transition:Transitioner()
    if player.collider:enter('Ghost') then
        return Gamestate.switch(runLevelOne)
    end
end

return transition