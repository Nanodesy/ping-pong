require "player"
require "ball"

GameState = {READY = 0, START = 1, PLAY = 2} 

Resources = {
	Sounds = {
		BallHitPlayer = love.audio.newSource("assets/hit.wav", "static"),
		Lose = love.audio.newSource("assets/lose.wav", "static")
	}
}

Game = {}

function Game:new()
	math.randomseed(os.time())

    local obj = {}
    obj.redPlayer = Player:new(PlayerType.RED, 60, 360)
    obj.bluePlayer = Player:new(PlayerType.BLUE, 1220, 360)
    obj.ball = Ball:new(WINDOW.WIDTH / 2, WINDOW.HEIGHT / 2)
	obj.state = GameState.READY
	obj.debug = false

	function obj:init()
		obj.messageFont = love.graphics.newFont(14)
		obj.scoreFont = love.graphics.newFont(128)
		love.window.setTitle("Ping Pong")
	end

	function obj:processInput()
		if obj.state == GameState.READY and love.keyboard.isDown("return") then
			obj.state = GameState.START
		end
	end

	function  obj:handleGameState()
		if obj.state == GameState.START then
			obj.ball:setRandomVelocity()
			obj.state = GameState.PLAY
		end
		if obj.ball:isOutsideLeftBound() then
			obj.bluePlayer.score = obj.bluePlayer.score + 1
			obj.state = GameState.READY
			obj:reset()
			Resources.Sounds.Lose:play()
		elseif obj.ball:isOutsideRightBound() then
			obj.redPlayer.score = obj.redPlayer.score + 1
			obj.state = GameState.READY
			obj:reset()
			Resources.Sounds.Lose:play()
		end
			
	end

    function obj:update(dt)
		obj:processInput()
		obj:handleGameState()
        obj.ball:update(dt)
        obj.redPlayer:update(dt)
        obj.bluePlayer:update(dt)
		obj.ball:handleCollision(obj.redPlayer)
		obj.ball:handleCollision(obj.bluePlayer)
    end

    function obj:render()
        obj.redPlayer:render()
        obj.bluePlayer:render()
        obj.ball:render()
		obj:renderGameState()
    end

	function obj:renderGameState()
		if obj.state == GameState.READY then
			love.graphics.setFont(obj.messageFont)
			love.graphics.printf("Press \"Enter\" to start...", WINDOW.WIDTH / 2 - 320, 10, 640, "center")
			love.graphics.setFont(obj.scoreFont)
			love.graphics.setColor(1, 0, 0)
			love.graphics.printf(obj.redPlayer.score, 160, 40, 160, "center")
			love.graphics.setColor(0, 0, 1)
			love.graphics.printf(obj.bluePlayer.score, 960, 40, 160, "center")
		end
	end

	function obj:reset()
		obj.ball:reset()
		obj.redPlayer:reset()
		obj.bluePlayer:reset()
		obj.state = GameState.READY
	end

	setmetatable(obj, self)
	self.__index = self
	return obj
end
