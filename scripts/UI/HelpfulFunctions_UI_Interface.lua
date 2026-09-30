print("=== Helpful Functions (UI) Loading ===")

function listObjectMethods(obj)
    for k, v in pairs(getmetatable(obj).__index) do
        print(k, v)
    end
end

function listKeyValuePairs(obj)
    for k, v in pairs(obj) do
        print(k, v)
    end
end

function listObjectMethodsFromItemList(itemList)
    for row in itemList() do
        listKeyValuePairs(row)
        return
    end
end

function PrintAllDistrictInfo()
    for district in GameInfo.Districts() do
        if district.TraitType == nil then
            PrintDistrictInfo(district.DistrictType)
        end
    end
end

function PrintDistrictInfo(districtType)
    local district = GameInfo.Districts[districtType]
    print(districtType)
    for k, v in pairs(district) do
        print("    " .. k, v)
    end
    local prereqBuildings = {}
    for building in GameInfo.Buildings() do
        if (
            building.PrereqDistrict == districtType and
            not building.InternalOnly and
            building.TraitType == nil and
            #building.ReplacesCollection == 0
        ) then
            prereqBuildings[building.BuildingType] = true
        end
    end
    for row in GameInfo.BuildingPrereqs() do
        if prereqBuildings[row.PrereqBuilding] ~= nil and prereqBuildings[row.Building] ~= nil then
            prereqBuildings[row.Building] = row.PrereqBuilding
        end
    end
    local buildingTiers = {}
    for buildingType in pairs(prereqBuildings) do
        local tier = 1
        local currentBuildingType = buildingType
        while currentBuildingType do
            currentBuildingType = prereqBuildings[currentBuildingType];
            if currentBuildingType ~= nil and currentBuildingType ~= true then
                tier = tier + 1
            end
        end
        if buildingTiers[tier] == nil then
            buildingTiers[tier] = {}
        end
        table.insert(buildingTiers[tier], buildingType)
    end

    local tiers = {}
    for k in pairs(buildingTiers) do
        table.insert(tiers, k)
    end
    table.sort(tiers)

    for _, tier in ipairs(tiers) do
        local buildings = buildingTiers[tier]
        for _, buildingType in pairs(buildings) do
            local info = GameInfo.Buildings[buildingType]
            print()
            print(buildingType, "Tier -> " .. tier)
            print("    InGame Name:", Locale.Lookup(info.Name))
            local keys = {}
            for k, _ in pairs(info) do
                table.insert(keys, k)
            end
            table.sort(keys)
            for _, k in ipairs(keys) do
                if k ~= "BuildingType" then
                    print("    " .. k .. ":", info[k])
                end
            end
        end
    end
end

function AddMapPins()
    local primaryCityCenterMapPins = {
        2323,
        2330,
        2337,
        3331,
        3346,
        4342,
        4349,
        4356,
    }
    local secondaryCityCenterMapPins = {
        2316,
        2344,
        2645,
        2926,
        3324,
        3497,
        4653,
        4803,
        5344,
        5351,
        5479,
    }
    local tertiaryCityCenterMapPins = {
        4329,
        5359,
        6352,
        6773,
        7067,
        7783,
        8077,
        9087,
        9369,
        10379,
    }
    local wonderMapPins = {
        ALHAMBRA = 6498,
        ANGKOR_WAT = 7062,
        CHICHEN_ITZA = 7788,
        COLOSSEUM = 2492,
        COLOSSUS = 2647,
        GREAT_LIBRARY = 3035,
        GREAT_LIGHTHOUSE = 2603,
        HAGIA_SOPHIA = 9227,
        HALICARNASSUS_MAUSOLEUM = 5480,
        HUEY_TEOCALLI = 4330,
        JEBEL_BARKAL = 4942,
        KILWA_KISIWANI = 7782,
        KOTOKU_IN = 5361,
        MACHU_PICCHU = 2200,
        MAHABODHI_TEMPLE = 3495,
        MEENAKSHI_TEMPLE = 10668,
        MONT_ST_MICHEL = 7068,
        PETRA = 4659,
        STATUE_OF_ZEUS = 5778,
        TERRACOTTA_ARMY = 5495,
        UNIVERSITY_SANKORE = 9233,
    }
    local config = PlayerConfigurations[0]
    for wonderName, plotID in pairs(wonderMapPins) do
        local name = "BUILDING_" .. wonderName
        local plot = Map.GetPlotByIndex(plotID)
        local x = plot:GetX()
        local y = plot:GetY()
        local pin = config:GetMapPin(x, y)
        local iconName = "ICON_" .. name
        local info = GameInfo.Buildings[name]
        if pin:GetIconName() ~= iconName then
            pin:SetIconName(iconName)
            pin:SetName("Wonder-" .. Locale.Lookup(info.Name))
            Network.BroadcastPlayerInfo()
        end
    end

    local function NeedsSafePlot(plot)
        local feature = plot:GetFeatureType()
        local info = GameInfo.Features[feature]
        if info == nil then
            return false
        end

        local featureType = info.FeatureType
        if string.find(featureType, "FOREST") then
            return true
        end

        if string.find(featureType, "JUNGLE") then
            return true
        end

        if string.find(featureType, "FLOODPLAINS") then
            return true
        end

        return false
    end

    for i = 1, #secondaryCityCenterMapPins do
        local plotID = secondaryCityCenterMapPins[i]
        local plot = Map.GetPlotByIndex(plotID)
        if not plot:IsCity() then
            local x = plot:GetX()
            local y = plot:GetY()
            local pin = config:GetMapPin(x, y)
            local iconName = "ICON_DISTRICT_CITY_CENTER"
            local pinName = "City Center"
            if pin:GetIconName() ~= iconName then
                if NeedsSafePlot(plot) then
                    pinName = "1 - needs a safe plot"
                    iconName = "ICON_NOTIFICATION_BARBARIANS_SIGHTED"
                end
                pin:SetIconName(iconName)
                pin:SetName(pinName)
                Network.BroadcastPlayerInfo()
            end
        end
    end

    for i = 1, #tertiaryCityCenterMapPins do
        local plotID = tertiaryCityCenterMapPins[i]
        local plot = Map.GetPlotByIndex(plotID)
        if not plot:IsCity() then
            local x = plot:GetX()
            local y = plot:GetY()
            local pin = config:GetMapPin(x, y)
            local iconName = "ICON_UNIT_SETTLER"
            local pinName = "2 - Settler Plot"
            if pin:GetIconName() ~= iconName then
                if NeedsSafePlot(plot) then
                    pinName = "1 - needs a safe plot"
                    iconName = "ICON_NOTIFICATION_BARBARIANS_SIGHTED"
                end
                pin:SetIconName(iconName)
                pin:SetName(pinName)
                Network.BroadcastPlayerInfo()
            end
        end
    end
end

function FixPinNames(playerID)
    if playerID == nil then
        playerID = Game.GetLocalPlayer()
    end

    local player = Players[playerID]
    if player == nil or not player:IsHuman() then
        return
    end

    local config = PlayerConfigurations[playerID]
    for _, pin in pairs(config:GetMapPins()) do
        if pin:GetName() == nil then
            local iconName = pin:GetIconName():gsub("^ICON_", "")
            local newName = nil
            local info = GameInfo.Buildings[iconName]
            if info ~= nil and info.IsWonder then
                newName = "Wonder-" .. Locale.Lookup(info.Name)
            elseif iconName == "UNIT_SETTLER" then
                newName = "Settler Safe Plot"
            elseif iconName == "DISTRICT_CITY_CENTER" then
                newName = "City Center"
            elseif GameInfo.Districts[iconName] ~= nil then
                local name = Locale.Lookup(GameInfo.Districts[iconName].Name)
                newName = "District-" .. name
            end

            if newName ~= nil then
                pin:SetName(newName)
                Network.BroadcastPlayerInfo()
            end
        end
    end
end

print("=== Helpful Functions (UI) Loaded ===")

ExposedMembers.HelpfulFunctions = ExposedMembers.HelpfulFunctions or {}
ExposedMembers.HelpfulFunctions.AddMapPins = AddMapPins

--ProductionPanel_CancelManagerSelection
--ProductionPanel_ProductionClicked
--ProductionPanel_ToggleManager
