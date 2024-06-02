-- ConeCast
-- Nirleka Dev 
-- June 1, 2024 

local Workspace = game:GetService("Workspace")

local ConePointDistribution = require("Math")

local ConeCast = {}

function ConeCast.Cast(origin, distance, edgeSize, numPoints)
    local points = ConePointDistribution.ConePointDistribution(origin, distance, edgeSize, numPoints)
    local hits = {}
    local totalHits = 0

    for _, point in ipairs(points) do
        local ray = Ray.new(point, Vector3.new(point.X, point.Y, point.Z) * edgeSize)
		local raycastParams = RaycastParams.new()

		local result = Workspace:Raycast(ray.Origin, ray.Direction, raycastParams)

        if result then
			totalHits = totalHits + 1
		end
    end

    if totalHits <= 0 then
		return hits
	end

	return hits
end

return ConeCast
