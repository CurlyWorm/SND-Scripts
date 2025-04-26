--=========================================================--
-- Script Name:    Critical mission crafter automation
-- Description:    Kinda automates critical missions
-- Author:         CurlyWorm
-- Version:        0.0.1
-- Requirements:
--    Artisan
-- How to use:
--    Place yourself directly next to a collection point
--    Then i suppose you start the script after configuring mission
--    Also make sure you disable the script yourself when it's below 1 minute left on the red alert, there's no checks for that atm
--    You should also make sure you've got food and macro set up in the recipe itself by opening it once if you need that
--=========================================================--

--====================== CONFIG ===========================--

Mission_name = "Work Ladders" -- mission you want to do, case insensitive

--===================== CODE START ========================--

Missions = {
    ["Work Ladders"] = 512,
    ["Kindling"] = 513,
    ["Fungal Building Materials"] = 514,
    ["Meteorite Drills"] = 515,
    ["Vacuum Muzzles"] = 516,
    ["Flamethrower Parts"] = 517,
    ["Spare Vacuum Tanks"] = 518,
    ["Vehicular Plating"] = 519,
    ["Gas Tanks"] = 520,
    ["Lighting Repair Tools"] = 521,
    ["Intricate Vacuum Parts"] = 522,
    ["Spare Vehicle Parts"] = 523,
    ["Impenetrable Gloves"] = 524,
    ["Reinforced Gas Masks"] = 525,
    ["Flame-resistant Workboots"] = 526,
    ["Spare Cloth"] = 527,
    ["Flame-resistant Work Cloth"] = 528,
    ["Fungal Cloth"] = 529,
    ["Aether-resistant Agent"] = 530,
    ["Gas Poisoning Antidote"] = 531,
    ["Flamethrower Fuel"] = 532,
    ["Cured Foodstuffs"] = 533,
    ["Nutrient Supplement Jelly"] = 534,
    ["Irregular Spongoi Analysis"] = 535,
}

function Find_mission_id(mission)
    local lower_search = mission:lower()
    for name, id in pairs(Missions) do
        if name:lower():find(lower_search, 1, true) then
            return id
        end
    end
    return nil
end

local mission_id = Find_mission_id(Mission_name)
if not mission_id then
    yield("/e [CMCAuto] Mission name not found, stopping script")
    return
end

while true do
    -- If the mission list isn't open, open it
    if not IsAddonReady("WKSMission") then
        yield("/callback WKSHud true 11")
    end

    -- Wait for mission list to be ready
    repeat
        yield("/wait 0.1")
    until IsAddonReady("WKSMission")

    -- Make sure we're on the right page
    yield("/callback WKSMission true 12 216 2 1")

    -- Start the mission, but only if there's available missions. Last part soontm
    yield("/callback WKSMission true 13 " .. mission_id)

    -- Wait for SelectYesno window and confirm
    repeat
        yield("/wait 0.1")
    until IsAddonReady("SelectYesno")
    yield("/callback SelectYesno true 0")

    -- Wait for SelectYesno window to close
    repeat
        yield("/wait 0.1")
    until not IsAddonVisible("SelectYesno")

    -- Wait for WKSRecipeNotebook to be ready
    repeat
        yield("/wait 0.1")
    until IsAddonReady("WKSRecipeNotebook")

    -- Set endurance mode to true
    ArtisanSetEnduranceStatus(true)
    yield("/wait 2")

    -- Wait for character to be available again and disable endurance
    repeat
        yield("/wait 0.1")
    until IsPlayerAvailable()

    ArtisanSetEnduranceStatus(false)

    -- Target the collection point to turn in
    repeat
        yield('/target "Collection Point"')
        yield("/wait 0.1")
    until tostring(GetTargetName()) == "Collection Point"

    yield("/interact")

    -- Wait for animation to start
    repeat
        yield("/wait 0.1")
    until GetCharacterCondition(31)

    -- Wait until animation is finished
    repeat
        yield("/wait 0.1")
    until IsPlayerAvailable()
    yield("/wait 0.5")
end
