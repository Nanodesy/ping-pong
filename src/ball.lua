local vector = require "vector"

local INITIAL_SPEED = 300

Ball = {}

function Ball:new(initX, initY)
	local obj = {}
	obj.initX = initX
	obj.initY = initY
	obj.X = initX
	obj.Y = initY
	obj.radius = 20
	obj.speed = INITIAL_SPEED
	obj.direction = {X = 0, Y = 0}
	obj.color = {r = 255, g = 255, b = 255, a = 255}

	function obj:setRandomVelocity()
		-- Random X position
		if math.random(2) == 2 then obj.direction.X = math.random(1, 3)
		else obj.direction.X = -math.random(1, 3) end
		-- Random Y position
		if math.random(2) == 2 then obj.direction.Y = math.random(1, 3)
		else obj.direction.Y = -math.random(1, 3) end
		-- Normalize vector
		obj.direction = vector.normalize(obj.direction.X, obj.direction.Y)
	end

	function obj:update(dt)
		obj:handleHorizontalSidesCollision()
		obj.X = obj.X + obj.direction.X * obj.speed * dt
		obj.Y = obj.Y + obj.direction.Y * obj.speed * dt
	end

	function obj:render()
		love.graphics.setColor(love.math.colorFromBytes{obj.color.r, obj.color.g, obj.color.b, obj.color.a})
		love.graphics.circle("fill", obj.X, obj.Y, obj.radius)
		if debug then -- If debug then draw collision boxes
			love.graphics.setColor(0, 1, 0)
			love.graphics.rectangle('line', obj.X - obj.radius, obj.Y - obj.radius, obj.radius * 2, obj.radius * 2)
		end
		love.graphics.setColor(1, 1, 1)
	end

	-- Collision

	function obj:handleHorizontalSidesCollision()
		if obj.Y <= obj.radius or obj.Y >= WINDOW.HEIGHT - obj.radius then
			obj.direction.Y = -obj.direction.Y
		end
	end

	function obj:isOutsideLeftBound()
		return obj.X <= obj.radius
	end

	function obj:isOutsideRightBound()
		return obj.X >= WINDOW.WIDTH - obj.radius
	end

	function obj:handleCollision(player)
		local isCollides = vector.is2DCollision(
			{X = obj.X - obj.radius, Y = obj.Y - obj.radius, width = obj.radius * 2, height = obj.radius * 2},
			{X = player.X - (player.width / 2), Y = player.Y - (player.height / 2), width = player.width, height = player.height}
		)

		if isCollides then
			obj.direction.X = -obj.direction.X
			obj.direction.Y = (obj.Y - player.Y) / player.height
			obj.direction = vector.normalize(obj.direction.X, obj.direction.Y)
			obj.speed = obj.speed * 1.10
			Resources.Sounds.BallHitPlayer:play()
		end
	end

	-- End collision

	function obj:reset()
		obj.X = obj.initX
		obj.Y = obj.initY
		obj.direction = {X = 0, Y = 0}
		obj.speed = INITIAL_SPEED
	end

	setmetatable(obj, self)
	self.__index = self
	return obj
end
