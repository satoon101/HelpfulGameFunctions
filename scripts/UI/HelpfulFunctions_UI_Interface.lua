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

print("=== Helpful Functions (UI) Loaded ===")

--ProductionPanel_CancelManagerSelection
--ProductionPanel_ProductionClicked
--ProductionPanel_ToggleManager
