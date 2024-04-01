-- ConeCast
-- Nirleka Dev / walterrellisfun
-- April 1, 2024 

local Physics = require("PhysicsModule")
local Vector3 = require("Vector3Module")

local Workspace = game:GetService("Workspace")

local ConeCastExtension = {}

function ConeCastExtension.ConeCastAll(origin, maxRadius, direction, maxDistance, coneAngle)
    local sphereCastHits = Workspace:Spherecast(origin, Vector3.new(0, 0, maxRadius), direction * maxDistance)
    local coneCastHitList = {}
    if #sphereCastHits > 0 then
        for i, hit in ipairs(sphereCastHits) do
            -- Assuming a way to access and modify the color of the material of the hit object
            -- This part is highly dependent on how the game objects and rendering are handled in the Lua environment
            if hit:IsA("Part") or hit:IsA("MeshPart") then
                hit.Color3 = Color3.new(1, 0, 0)
            end
            local hitPoint = hit.point
            local directionToHit = Vector3.Subtract(hitPoint, origin)
            local angleToHit = Vector3:Angle(direction, directionToHit)
            if angleToHit < coneAngle then
                table.insert(coneCastHitList, hit)
            end
        end
    end
    return coneCastHitList
end

return ConeCastExtension

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