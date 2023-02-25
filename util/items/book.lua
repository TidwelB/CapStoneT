book = {}
    book.spritesheet = love.graphics.newImage("sprites/book.png")
    book.x = 1390
    book.y = 300
    book.h = book.spritesheet:getHeight()
    book.w = book.spritesheet:getWidth()
    book.scale = 3
    book.room = "levelThree"

function book:draw()
    if checkInventory(inventory, "book") == false then
    if book.room == room then
        love.graphics.draw(book.spritesheet,book.x,book.y,0,book.scale,book.scale)
        --print("drawing")
    end
end

end

function book.load()
    book.x = data.bookpos.x
    book.y = data.bookpos.y
    book.room = data.bookpos.room
end