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

--[[
    -- Lua does not have a direct equivalent of RaycastHit, Physics, or Vector3 from Unity.
-- This translation will focus on the logic and structure, assuming similar functionalities are implemented in Lua.

-- Assuming a Lua module or table that provides physics functionalities similar to Unity's Physics
local Physics = require("PhysicsModule")

-- Assuming a Lua module or table that provides vector functionalities similar to Unity's Vector3
local Vector3 = require("Vector3Module")

local ConeCastExtension = {}

function ConeCastExtension.ConeCastAll(origin, maxRadius, direction, maxDistance, coneAngle)
    local sphereCastHits = Physics.SphereCastAll(Vector3.Subtract(origin, Vector3.New(0, 0, maxRadius)), maxRadius, direction, maxDistance)
    local coneCastHitList = {}
    if #sphereCastHits > 0 then
        for i, hit in ipairs(sphereCastHits) do
            -- Assuming a way to access and modify the color of the material of the hit object
            -- This part is highly dependent on how the game objects and rendering are handled in the Lua environment
            hit.collider.gameObject.GetComponent("Renderer").material.color = Vector3.New(1, 1, 1)
            local hitPoint = hit.point
            local directionToHit = Vector3.Subtract(hitPoint, origin)
            local angleToHit = Vector3.Angle(direction, directionToHit)
            if angleToHit < coneAngle then
                table.insert(coneCastHitList, hit)
            end
        end
    end
    -- Directly returning the list as Lua tables can act as arrays
    return coneCastHitList
end

return ConeCastExtension
--]]