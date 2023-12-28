require "game"

WINDOW = {WIDTH = 1280, HEIGHT = 720}
Game = Game:new()

function love.load()
    love.window.setMode(WINDOW.WIDTH, WINDOW.HEIGHT)
    love.graphics.setDefaultFilter( "nearest", "nearest")
    Game:init()
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:render()
end
