print("=== Helpful Functions (UI) Loading ===")

function ProductionPanel_CancelManagerSelection(...)
    print("LuaEvents.ProductionPanel_CancelManagerSelection:", ...)
end

LuaEvents.ProductionPanel_CancelManagerSelection.Add(ProductionPanel_CancelManagerSelection)

function ProductionPanel_ProductionClicked(...)
    print("LuaEvents.ProductionPanel_ProductionClicked:", ...)
end

LuaEvents.ProductionPanel_ProductionClicked.Add(ProductionPanel_ProductionClicked)

function ProductionPanel_ToggleManager(...)
    print("LuaEvents.ProductionPanel_ToggleManager:", ...)
end

LuaEvents.ProductionPanel_ToggleManager.Add(ProductionPanel_ToggleManager)

print("=== Helpful Functions (UI) Loaded ===")

--ProductionPanel_CancelManagerSelection
--ProductionPanel_ProductionClicked
--ProductionPanel_ToggleManager
