-- KoS
-- Nirleka Dev
-- March 31, 2024

local Players = game:GetService("Players")

local function getPlayerDataModel(target)
	if target then
		if type(target) == "string" then
			for _, p in pairs(Players:GetChildren()) do
				if p.Name == target or p.DisplayName == target then
					return p
				end
			end
		elseif type(target) == "number" then
			for _, p in pairs(Players:GetChildren()) do
				if p:IsA("Player") and p.UserId == target then
					return p
				end
			end
		elseif target:IsA("Model") then
			for _, p in pairs(Players:GetChildren()) do
				if p.Name == target.Name or p.DisplayName == target.Name then
					return p
				end
			end
		elseif target:IsA("Player") then
			return target
		end
	end
end

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

function KoS:GetPlayer(target)
	local player = getPlayerDataModel(target)
	
	for i, p in ipairs(self.Players) do
		if p.player == player then
			return p
		end
	end
end

function KoS:Assert(target, reason)
	local player = getPlayerDataModel(target)
	if player then
		if self:GetPlayer(player) then
			return
		end

		local playerData = {
			player = player,
			reason = reason
		}
		table.insert(self.Players, playerData)

		return playerData
	end
end

function KoS:Lift(target)
	local get = self:GetPlayer(target)
	if get then
		table.remove(self.Players, get.index)
	end
end

function KoS:InsertHighlight(target)
	local player = getPlayerDataModel(target)
	local getPlayer = self:GetPlayer(player)
	local playerCharacter = getPlayer and player.Character

	if not playerCharacter then
		return
	end

	local highlight = playerCharacter:FindFirstChild(self._defaultHighlightName)
	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = self._defaultHighlightName
		highlight.FillColor = self.HighlightFillColor
		highlight.OutlineColor = self.HighlightOutlineColor
		highlight.FillTransparency = 0.5
		highlight.Enabled = true
		highlight.Parent = playerCharacter
	end

	local torso = playerCharacter:FindFirstChild("Torso")
	if torso then
		local pointLight = torso:FindFirstChild(self._defaultPointLightName)
		if not pointLight then
			pointLight = Instance.new("PointLight")
			pointLight.Name = self._defaultPointLightName
			pointLight.Color = self.PointLightColor
			pointLight.Range = 8
			pointLight.Brightness = 3
			pointLight.Parent = torso
		end
	end
end

function KoS:DestroyHighlight(target)
	local player = getPlayerDataModel(target)
	local getPlayer = self:GetPlayer(player)
	local playerCharacter = getPlayer and player.Character

	if not playerCharacter then
		return
	end

	local highlight = playerCharacter:FindFirstChild(self._defaultHighlightName)
	if highlight then
		highlight:Destroy()
	end

	local torso = playerCharacter:FindFirstChild("Torso")
	if torso then
		local pointLight = torso:FindFirstChild(self._defaultPointLightName)
		if pointLight then
			pointLight:Destroy()
		end
	end
end

return KoS