-- ===========================================================================
--  Helpful Functions - Gameplay Script
--  Provides helpful Lua functions that can be called during a match
-- ===========================================================================

print("=== Helpful Functions (Gameplay) Loading ===")

function resetCurrentTechProgress()
    local playerID = Game.GetLocalPlayer()
    local player = Players[playerID]
    local techs = player:GetTechs()
    local techIndex = techs:GetResearchingTech()
    techs:SetResearchProgress(techIndex, 0);
end

function resetCurrentCultureProgress()
    local playerID = Game.GetLocalPlayer()
    local player = Players[playerID]
    local culture = player:GetCulture()
    local cultureIndex = culture:GetProgressingCivic()
    culture:SetCulturalProgress(cultureIndex, 0);
end

print("=== Helpful Functions (Gameplay) Loaded ===")
