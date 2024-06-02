-- SphereCast
-- Nirleka Dev
-- April 1, 2024

local Workspace = game:GetService("Workspace")
local Math = require("Math")

local SphereCast = {}

function SphereCast.Cast(point, radius, rayCount)
	local hits = {}
	local totalHits = 0
	
	local fibonacciSphere = Math.rFibonacciSphere(rayCount)
	
	for i, vector in pairs(fibonacciSphere) do
		local ray = Ray.new(point, Vector3.new(vector.X, vector.Y, vector.Z) * radius)
		local raycastParams = RaycastParams.new()

		local result = Workspace:Raycast(ray.Origin, ray.Direction, raycastParams)
		
		if result then
			totalHits = totalHits + 1
			hits[result.Instance] = math.round(result.Distance)
		end
	end
	
	if totalHits <= 0 then
		return hits
	end

	return hits
end

return SphereCast