-- KoS
-- Nirleka Dev
-- March 31, 2024


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local KoS = {}
KoS.__index = KoS

function KoS.new(highlightFillColor, highlightOutlineColor, pointLightColor)
    local self = setmetatable({}, KoS)

    self.Players = {}

    self._defaultHighlightName = "KoS_Highlight"
    self._defaultPointLightName = "KoS_PointLight"

    self.HighlightFillColor = highlightFillColor or Color3.fromRGB(255, 0, 0)
	self.HighlightOutlineColor = highlightOutlineColor or Color3.fromRGB(255, 0, 0)
	self.PointLightColor = pointLightColor or Color3.fromRGB(255, 0, 0)

    return self
end

function KoS:GetPlayers()
    return self.Players
end

function KoS:GetPlayer(player)
    for i, v in pairs(self.Players) do
        if v.name == player then
            return {
                name = v.name,
                index = i
            }
        else
            return nil
        end
    end
end

function KoS:Assert(target, reason)
    local player 

    if type(target == "string") then
        if Players[target] then
            player = target
        end
    elseif type(target == "number") then
        for _, p in pairs(Players) do
            if p:IsA("Player") then
                if p.UserId == target then
                    player = p.Name
                end
            end
        end
    elseif target:IsA("Model") then
        if Players[target.Name] then
            player = target.Name
        end
    end

    if self:GetPlayer(player) then return end

    local playerData = {
        name = player,
        reason = reason
    }
    table.insert(playerData, self.Players)

    return playerData
end

function KoS:Lift(target)
    local get = self:GetPlayer()
    if get then
        table.remove(get.name, get.index)
    end
end

function KoS:InsertHighlight(target)
    local playerCharacter 
    if self:GetPlayer(target) then
        local character = Workspace[target]
        if character then
            playerCharacter = character
        end
    end

    local highlight = playerCharacter:FindFirstChild(self._defaultHighlightName)
    if highlight then
        return
    else
        local newHighlight = Instance.new("Highlight")
		newHighlight.Name = self._defaultHighlightName
		newHighlight.FillColor = self.HighlightFillColor
		newHighlight.OutlineColor = self.HighlightOutlineColor
		newHighlight.FillTransparency = 0.5
		newHighlight.Enabled = true
		newHighlight.Parent = playerCharacter
    end

    local torso = playerCharacter:FindFirstChild("Torso")
    if not torso then
        return
    else
        local pointLight = torso:FindFirstChild(self._defaultPointLightName)
        if pointLight then
            return
        else
            local newLight = Instance.new("PointLight")
            newLight.Name = self._defaultPointLightName
            newLight.Color = self.PointLightColor
            newLight.Range = 8
            newLight.Brightness = 3
            newLight.Parent = torso
        end
    end
end

function KoS:DestroyHighlight(target)
    local playerCharacter 
    if self:GetPlayer(target) then
        local character = Workspace[target]
        if character then
            playerCharacter = character
        end
    end

    local highlight = playerCharacter:FindFirstChild(self._defaultHighlightName)
    if highlight then
        highlight:Destroy()
    end

    local torso = playerCharacter:FindFirstChild("Torso")
    if not torso then
        return
    else
        local pointLight = torso:FindFirstChild(self._defaultPointLightName)
        if pointLight then
            pointLight:Destroy()
        end
    end
end

return KoS