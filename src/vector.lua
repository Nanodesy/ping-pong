local vector = {}

function vector.normalize(x, y)
    local len = math.sqrt(x * x + y * y)
	local result = {X = x, Y = y}
    if len ~= 0 and len ~= 1 then
        result.X = x / len
        result.Y = y / len
    end
	return result
end

function vector.is2DCollision(object1, object2)
	return object1.X < object2.X + object2.width 
	and object1.X + object1.width > object2.X 
	and object1.Y < object2.Y + object2.height 
	and object1.Y + object1.height > object2.Y
end

return vector
