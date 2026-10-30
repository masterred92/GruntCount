-- Grunt Count: two gag countdown voices for BigWigs (BigWigs > Countdown > Voice). Vanilla NPCs don't count out loud,
-- so each number is a grunt instead: 5 murloc, 4 kobold, 3 gnoll, 2 goblin, 1 gnome. Registered with
-- BigWigsAPI:RegisterCountdown; BigWigs plays them (by FileDataID) wherever it runs a countdown. Nothing bundled.
local _, ns = ...

-- data[i] is the sound BigWigs plays when it reaches number i
ns.Voices = {
  { id = "GruntCount: Critters", name = "Grunt Count: Critters", data = {
    550357, -- 1 gnome
    550515, -- 2 goblin
    550351, -- 3 gnoll
    553311, -- 4 kobold ("You no take candle!")
    555997, -- 5 murloc
  } },
  { id = "GruntCount: Work Work", name = "Grunt Count: Work Work", data = {
    558137, -- 1 peon: ready to work
    558119, -- 2 peasant: yes
    558128, -- 3 peasant: what
    558136, -- 4 peon: yes
    558141, -- 5 peon: what
  } },
}

function ns.Register()

-- While BigWigs counts down (the last 5 seconds of a countdown bar), our other addons' voice lines stay quiet,
-- so a "Job's done!" never talks over the count. Message from BigWigs Core/BossPrototype*.lua.
local COUNT_FROM = 5
function ns.OnStartCountdown(_, _, _, _, seconds)
  seconds = tonumber(seconds)
  if not seconds or (issecretvalue and issecretvalue(seconds)) then return end
  local wait = math.max(0, seconds - COUNT_FROM)
  C_Timer.After(wait, function() ns.Hub.MarkVoiceBusy(math.min(seconds, COUNT_FROM) + 1) end)
end
function ns.HookCountdowns()
  if ns.countHooked or type(BigWigsLoader) ~= "table" or type(BigWigsLoader.RegisterMessage) ~= "function" then return ns.countHooked end
  ns.countHooked = pcall(BigWigsLoader.RegisterMessage, ns, "BigWigs_StartCountdown", ns.OnStartCountdown)
  return ns.countHooked
end
ns.HookCountdowns()

ns.Core.Setup({ cmd = "/gruntcount", required = { "PlaySoundFile", "C_Timer.After" },
  optional = { "BigWigsAPI.RegisterCountdown", "BigWigsLoader.RegisterMessage" },
  debugLines = function()
    return { "voices registered with BigWigs: " .. tostring(ns.registered == true),
      "quiet for other voice lines during BigWigs countdowns: " .. tostring(ns.countHooked == true) }
  end })
  if ns.registered or type(BigWigsAPI) ~= "table" or type(BigWigsAPI.RegisterCountdown) ~= "function" then return ns.registered end
  local n = 0
  for _, v in ipairs(ns.Voices) do
    -- pcall: BigWigs errors if the id is already registered (e.g. after /reload with another copy)
    if pcall(BigWigsAPI.RegisterCountdown, BigWigsAPI, v.id, v.name, v.data) then n = n + 1 end
  end
  ns.registered = n > 0
  return ns.registered
end

ns.Register()

local function say(msg) print("|cff9acd32Grunt Count|r: " .. msg) end

SLASH_GRUNTCOUNT1 = "/gruntcount"
SlashCmdList.GRUNTCOUNT = function(msg)
  msg = strtrim((msg or ""):lower())
  if msg == "debug" then ns.Core.PrintDebug() return end
  local pick = (msg == "work" and ns.Voices[2]) or ((msg == "critters" or msg == "test") and ns.Voices[1])
  if not pick then
    say("pick a voice in BigWigs > Countdown. Preview: /gruntcount critters or /gruntcount work. Setup check: /gruntcount debug")
    if not ns.registered then say("BigWigs isn't loaded, so the voices aren't registered.") end
    return
  end
  if InCombatLockdown() then say("not in combat.") return end
  ns.Hub.MarkVoiceBusy(6) -- our other addons wait until the preview is over
  for n = 5, 1, -1 do
    C_Timer.After(5 - n, function() if not InCombatLockdown() then pcall(PlaySoundFile, pick.data[n], "Master") end end)
  end
  say(pick.name .. ": 5... 4... 3... 2... 1...")
end
