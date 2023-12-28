Player = {}

PlayerType = {RED = 0, BLUE = 1}

local RED_PLAYER_COLOR = {r = 248, g = 206, b = 204, a = 255}
local RED_PLAYER_KEYBINDINGS = {UP = "w", DOWN = "s"}

local BLUE_PLAYER_COLOR = {r = 218, g = 232, b = 252, a = 255}
local BLUE_PLAYER_KEYBINDINGS = {UP = "up", DOWN = "down"}


function Player:new(playerType, initX, initY)
	local obj = {}
	obj.initX = initX
	obj.initY = initY
	obj.X = initX
	obj.Y = initY
	obj.width = 40
	obj.height = 120
	obj.speed = 500
	obj.score = 0
	if playerType == PlayerType.RED then
		 obj.color = RED_PLAYER_COLOR
		 obj.keybindings = RED_PLAYER_KEYBINDINGS
	else 
		obj.color = BLUE_PLAYER_COLOR
		obj.keybindings = BLUE_PLAYER_KEYBINDINGS
	end

	function obj:update(dt)
		if (Game.state == GameState.PLAY) then
			if love.keyboard.isDown(obj.keybindings.UP) then
				obj.Y = math.max(obj.height / 2, obj.Y + -obj.speed * dt)
			elseif love.keyboard.isDown(obj.keybindings.DOWN) then
				obj.Y = math.min(WINDOW.HEIGHT - obj.height / 2, obj.Y + obj.speed * dt)
			end
		end
	end

	function obj:render()
		love.graphics.setColor(love.math.colorFromBytes{obj.color.r, obj.color.g, obj.color.b, obj.color.a})
		love.graphics.rectangle("fill", obj.X - (obj.width / 2) , obj.Y - (obj.height / 2), obj.width, obj.height)
		if debug then -- If debug then draw collision boxes
			love.graphics.setColor(0, 1, 0)
			love.graphics.rectangle('line', obj.X - (obj.width / 2), obj.Y - (obj.height / 2), obj.width, obj.height)
		end
		love.graphics.setColor(1, 1, 1)
	end

	function obj:reset()
		obj.X = obj.initX
		obj.Y = obj.initY
	end

	setmetatable(obj, self)
	self.__index = self
	return obj
end
