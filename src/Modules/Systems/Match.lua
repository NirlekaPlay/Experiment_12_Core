-- Match
-- Nirleka Dev
-- March 28, 2024

local Player = require(script.Player)
local Teleport = require(script.Teleport)
local Timer = require(game.ReplicatedStorage.Utility.Timer)

local Match = {}
Match.__index = Match

function Match.new(spawnsFolder, defSpawn)
	local self = setmetatable({}, Match)
    self.states = {}
	self.players = {}
	self.spawns = spawnsFolder or {}

	self.clock = 0

	self.defSpawn = defSpawn
	self.currentState = nil

	self.minPlayers = 1
	self._teleport = Teleport.new(self.spawns, self.defSpawn)
	self._timer = Timer.new()

	self.UpdateUi = Instance.new("RemoteEvent", script)
	return self
end

function Match:GetTimer()
	return self._timer
end

function Match:_updateUi()
	self.UpdateUi:FireAllClients(self._timer:getTime(), self.currentState)
end

function Match:AddPlayer(player)
	if not Player.MadworkPlayerCheck(player) then return end
	table.insert(self.players, player)
end

function Match:RemovePlayer(player)
	if not Player.MadworkPlayerCheck(player) then return end
	for i, plr in ipairs(self.players) do
		if plr == player then
			table.remove(self.players, i)
			break
		end
	end
end

function Match:OnPlayerJoined(player)
	if not Player.MadworkPlayerCheck(player) then return end
	local currentState = self.states[self.currentState]
	if currentState and currentState.OnPlayerJoined then
		currentState.OnPlayerJoined(self, player)
	end
end

function Match:AddState(name, state)
	self.states[name] = state
end

function Match:TransitionToState(name)
	local state = self.states[name]
	if state then
		self.currentState = name
		self.clock = 0
		self._timer:reset()
		if state.Duration then
			self._timer:start(state.Duration)
		end
		self:_updateUi()
		if state.OnEnter then
			state.OnEnter(self)
		end
	end
end

function Match:Update()
	local currentState = self.states[self.currentState]
	if currentState and currentState.Update then
		currentState.Update(self)
	end
end

return Match
