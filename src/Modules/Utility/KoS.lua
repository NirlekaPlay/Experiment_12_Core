-- KoS
-- Nirleka Dev
-- March 31, 2024

--[[

    Mark players as Kill on Sight (KoS), and storing them in table so that they will still have the KoS
	effect after death.

	METHODS:
	        
	        KoS.new(hFillColor, hOutlineColor, lightColor)   Creates a new table to store KoS players.
			KoS:GetPlayer(target)                            Returns the player's data if they are in the table.
			KoS:GetPlayers()                                 Returns all players in the table.
			KoS:Assert(target, reason)                       Inserts the player in the table. Accepts player name, player id, and player character.
			KoS:Lift(target)                                 Removes the player from the table.
			KoS:InsertHighlight(target)                      Inserts a highlight and point light object in to the player's character.
			KoS:DestroyHighlight(target)                     Destroys the highlight and point light object from the player's character.

	EXAMPLE:

	        local Players = game:GetService("Players")
            local KoS = require(this).new()

            local function onPlayerAdded(player)
	            local check = KoS:GetPlayer(player)
	            if check then
		            KoS:InsertHighlight(player)
	            end
            end

            Players.PlayerAdded:Connect(onPlayerAdded)

            ---

            KoS:Assert("NirlekaPlay", "Menace to society")
            KoS:Lift("NirlekaPlay")
	
--]]

local Players = game:GetService("Players")

local function getPlayerDataModel(target)
	if not target then
		return
	end

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
	end 
		
	local pointLight = torso:FindFirstChild(self._defaultPointLightName)
	if not pointLight then
		local newPointLight = Instance.new("PointLight")
		newPointLight.Name = self._defaultPointLightName
		newPointLight.Color = self.PointLightColor
		newPointLight.Range = 8
		newPointLight.Brightness = 3
		newPointLight.Parent = torso
	end
end

function KoS:DestroyHighlight(target)
	local player = getPlayerDataModel(target)
	if not player then
		return
	end

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
	if not torso then
		return
	end

	local pointLight = torso:FindFirstChild(self._defaultPointLightName)
	if pointLight then
		pointLight:Destroy()
	end
end

return KoS