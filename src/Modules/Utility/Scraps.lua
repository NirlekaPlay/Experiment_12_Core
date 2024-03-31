-- Scraps
-- Nirleka Dev
-- March 31, 2024

local Math = require("Math")

local Scraps = {}
Scraps.__index = Scraps

function Scraps.new(scrapTypes)
    local self = setmetatable({}, Scraps)

    self.Scraps = {}
    
    self.ScrapTypes = scrapTypes
end

