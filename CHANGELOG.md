# Changelog

## 1.1.0
- Other voice addons in the family (BRBoss, Wipe & Win, Job's Done) wait until a countdown has finished.
- `/gruntcount debug` checks your setup: client version, every game API the addon needs, and which of Kenny's other addons it is working with.
- A loud chat warning if this client is missing an API the addon needs, instead of failing silently.
- English text now lives in `Locales/enUS.lua`, ready for translations.
- Shared code (KennyShared) is identical in every addon of the family and checked in CI, along with every Blizzard API call (against the Forever UI source) and every DBM/BigWigs/Questie API call (against their source).

## 1.0.0 (first release)
- First release. Two BigWigs countdown voices (Critters and Work Work) via BigWigsAPI:RegisterCountdown, with a `/gruntcount` preview.
- Game version: WoW: Forever 1.60.1 (Interface 16001).
