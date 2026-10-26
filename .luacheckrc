std = "lua51"
max_line_length = false
exclude_files = { "tests/**", "tools/**", ".release/**", ".lua/**", ".luarocks/**" }
-- Our own globals.
globals = { "SLASH_GRUNTCOUNT1", "SlashCmdList" }
-- WoW API (checked against Blizzard's UI source by tools/verify_api.py) and host-addon globals (tools/host_api.py).
read_globals = { "BigWigsAPI", "C_Timer", "InCombatLockdown", "PlaySoundFile", "strtrim" }
