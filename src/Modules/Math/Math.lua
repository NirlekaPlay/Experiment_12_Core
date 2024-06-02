-- Math
-- Nirleka Dev
-- March 31, 2024

local Math = {}

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

function Math.GoldenRatioSphere()
	local goldenRatio = (1 + math.sqrt(5)) / 2
	local angleIncrement = math.pi * 2 * goldenRatio

	local y = 1 - (2 * math.random())
	local radius = math.sqrt(1 - y * y)
	local theta = angleIncrement * math.random()

	local x = math.cos(theta) * radius
	local z = math.sin(theta) * radius

	return Vector3.new(x, y, z)
end

function Math.qFibonacciSphere(samples)
	samples = samples or 1000
	local points = {}
	local phi = math.pi * (math.sqrt(5) - 1) 

	for i = 1, samples do
		local y = 1 - (i / (samples - 1)) * 2  
		local radius = math.sqrt(1 - y * y)  

		local theta = phi * i  

		local x = math.cos(theta) * radius
		local z = math.sin(theta) * radius

		table.insert(points, Vector3.new(x, y, z))
	end

	return points
end

function Math.rFibonacciSphere(samples)
	samples = samples or 1000
	local points = {}
	local phi = math.pi * (math.sqrt(5) - 1)
	local offset = math.random() * math.pi * 2 -- Random offset for theta angle

	for i = 1, samples do
		local y = 1 - (i / (samples - 1)) * 2
		local radius = math.sqrt(1 - y * y)

		local theta = phi * i + offset -- Add random offset to theta

		local x = math.cos(theta) * radius
		local z = math.sin(theta) * radius

		table.insert(points, Vector3.new(x, y, z))
	end

	return points
end

function Math.ConePointDistribution(origin, distance, edgeSize, numPoints)
	local points = {}

	for i = 0, numPoints - 1 do
		local angle = (2 * math.pi * i) / numPoints
		local x = edgeSize * math.cos(angle)
		local y = distance
		local z = edgeSize * math.sin(angle)
		local point = origin + Vector3.new(x, y, z)
		table.insert(points, point)
	end

	return points
end

return Math