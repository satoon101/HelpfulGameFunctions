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
    techs:SetResearchProgress(techIndex, 0)
end

function resetCurrentCultureProgress()
    local playerID = Game.GetLocalPlayer()
    local player = Players[playerID]
    local culture = player:GetCulture()
    local cultureIndex = culture:GetProgressingCivic()
    culture:SetCulturalProgress(cultureIndex, 0)
end

function listObjectMethods(obj)
    for k, v in pairs(getmetatable(obj).__index) do
        print(k, v)
    end
end

function listObjectMethodsFromItemList(itemList)
    for row in itemList() do
        listObjectMethods(row)
        return
    end
end

function listNeededDistrictsByCity()
    local player = Players[0]
    local cities = player:GetCities()
    for _, city in cities:Members() do
        local districts = city:GetDistricts()
        local districtTypeTable = {
            ["DISTRICT_COMMERCIAL_HUB"] = "commerce",
            ["DISTRICT_HARBOR"] = "commerce",
            ["DISTRICT_ENTERTAINMENT_COMPLEX"] = "entertainment",
            ["DISTRICT_WATER_ENTERTAINMENT_COMPLEX"] = "entertainment",
            ["DISTRICT_ENCAMPMENT"] = "extra",
            ["DISTRICT_CAMPUS"] = "extra",
            ["DISTRICT_HOLY_SITE"] = "extra",
            ["DISTRICT_THEATER"] = "theater",
            ["DISTRICT_INDUSTRIAL_ZONE"] = "power",
        }
        local flagTable = {
            ["commerce"] = false,
            ["entertainment"] = false,
            ["extra"] = false,
            ["theater"] = false,
            ["power"] = false,
        }
        for _, district in districts:Members() do
            local districtType = GameInfo.Districts[district:GetType()].DistrictType
            flagTable[districtTypeTable[districtType]] = true
        end
        local foundAll = true
        for _, value in pairs(flagTable) do
            if value ~= true then
                foundAll = false
            end
        end
        if not foundAll then
            print(Locale.Lookup(city:GetName()))
            for key, value in pairs(flagTable) do
                if not value then
                    print("    Needs " .. key .. " district")
                end
            end
        end
    end
end

print("=== Helpful Functions (Gameplay) Loaded ===")
