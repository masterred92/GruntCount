package.path = "./tests/?.lua;" .. package.path
local M = require("mock_wow")
M.install()
local voices = {}
BigWigsAPI = {}
function BigWigsAPI:RegisterCountdown(id, name, data) -- same checks as BigWigs API.lua
  if not data then data, name = name, id end
  assert(type(id) == "string")
  if type(data) ~= "table" or #data < 5 or #data > 10 then error("5-10 entries") end
  if voices[id] then error("already registered") end
  voices[id] = { name = name, data = data }
end
local ns = M.loadAddon(".", "GruntCount")
M.check(voices["GruntCount: Critters"] and voices["GruntCount: Work Work"], "both voices registered")
M.check(voices["GruntCount: Critters"].data[5] == 555997, "5 = murloc")
for _, v in pairs(voices) do for i = 1, 5 do M.check(type(v.data[i]) == "number", "FileDataID " .. i) end end
ns.registered = nil
M.check(ns.Register() == false, "re-register refused safely by BigWigs, no error")
M.slash("/gruntcount", "critters")
M.advance(5)
M.check(#M.sounds == 5 and M.sounds[1][1] == 555997 and M.sounds[5][1] == 550357, "preview counts 5 to 1")
M.combat = true; M.slash("/gruntcount", "work"); M.advance(5); M.combat = false
M.check(#M.sounds == 5, "no preview in combat")
M.done("GruntCount")
