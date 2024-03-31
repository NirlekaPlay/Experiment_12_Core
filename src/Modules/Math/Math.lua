-- Math
-- Nirleka Dev
-- March 31, 2024

local Math = {}

function Math.CalculateArea(b, h, r)
    if b and h then
        return b * h
    elseif not b and h then
        if r then
            return math.pi * r * r
        end
    end
end

function Math.RandomPointOnPlane(position, size)
    local x = position.X
    local z = position.Z

    local xS = size.X/2
    local xZ = size.Z/2

    local pos1 = math.random(x-xS, x+xS)
    local pos2 = math.random(z-xZ, z+xZ)

    local randomPosition = Vector3.new(pos1, 3, pos2)
    return randomPosition
end

function Math.GetRandomUnitVector()
	local goldenRatio = (1 + math.sqrt(5)) / 2
	local angleIncrement = math.pi * 2 * goldenRatio

	local y = 1 - (2 * math.random())
	local radius = math.sqrt(1 - y * y)
	local theta = angleIncrement * math.random()

	local x = math.cos(theta) * radius
	local z = math.sin(theta) * radius

	return Vector3.new(x, y, z)
end



return Math