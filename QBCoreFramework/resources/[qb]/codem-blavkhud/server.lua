local preferences = {}

function GetPreferencesData()
    local json_data = LoadResourceFile(GetCurrentResourceName(),  './preferences.json')
    if(json_data == '')then
        json_data = {}
    else
        json_data = json.decode(json_data)
    end
    return json_data
end

function SaveToPreferencesData(data)
    SaveResourceFile(GetCurrentResourceName(),'preferences.json', json.encode(data), -1)
end
Citizen.CreateThread(function()
    Citizen.Wait(2000)

    for _,v in pairs(GetPlayers()) do
    
        local identifier = GetIdentifier(v)
      
    
        if preferences[identifier] == nil then
         
            preferences[identifier] = {
                hud = "venicehud",
                hide = false,
                cinematic = false,
                speedtype = "kmh",
                compassPos = "top",
                showcompass = true,
            }
            SaveToPreferencesData(preferences)
        end
        TriggerClientEvent("codem-elegant-hud:GetPreferences", v, preferences[identifier])
    end
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    preferences = GetPreferencesData()
end)

function GetIdentifier(playerId)
    local identifier
    
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = v
			break
		end
	end
    if identifier == nil then
    for k,v in ipairs(GetPlayerIdentifiers(playerId)) do

		if string.match(v, 'steam:') then
			identifier = v
			break
		end
	end
    end
    return identifier
end

RegisterServerEvent('codem-elegant-hud:SaveShowCompass')
AddEventHandler('codem-elegant-hud:SaveShowCompass', function(toggle)
    local src = source
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = "venicehud",
            hide = false,
            cinematic = false,
            speedtype = "kmh",
            compassPos = "top",
            showcompass = toggle,

        }
    end
    preferences[identifier].showcompass = toggle
    SaveToPreferencesData(preferences)
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
end)

RegisterServerEvent("QBCore:Server:OnPlayerLoaded")
AddEventHandler("QBCore:Server:OnPlayerLoaded", function()
    local src = source
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = "venicehud",
            hide = false,
            cinematic = false,
            speedtype = "kmh",
            compassPos = "top",
            showcompass = true,
        }
        SaveToPreferencesData(preferences)
    end
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
end)

RegisterServerEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(targetSrc)
    local src = targetSrc and targetSrc or source
   
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = "venicehud",
            hide = false,
            cinematic = false,
            speedtype = "kmh",
            compassPos = "top",
            showcompass = true,

        }
        SaveToPreferencesData(preferences)
    end
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
end)

-- RegisterCommand("loadhud", function(source)
--     local src = source
--     local identifier = GetIdentifier(src)
--     if preferences[identifier] == nil then
--         preferences[identifier] = {
--             hud = "venicehud",
--             hide = false,
--             cinematic = false,
--             speedtype = "kmh",
--             compassPos = "top",
--             showcompass = true,

        
--         }
--         SaveToPreferencesData(preferences)
--     end
--     TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
-- end)

RegisterServerEvent('codem-elegant-hud:SaveCinematicMode')
AddEventHandler('codem-elegant-hud:SaveCinematicMode', function(toggle)
    local src = source
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = "venicehud",
            hide = false,
            cinematic = toggle,
            speedtype = "kmh",
            compassPos = "top",
            showcompass = true,

        }
    end
    preferences[identifier].cinematic = toggle
    SaveToPreferencesData(preferences)
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])

end)

RegisterServerEvent('codem-elegant-hud:ChangeSpeedType')
AddEventHandler('codem-elegant-hud:ChangeSpeedType', function(type)
    local src = source
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = "venicehud",
            hide = false,
            cinematic = false,
            speedtype = type,
            compassPos = "top",
            showcompass = true,

        }
    end
    preferences[identifier].speedtype = type
    SaveToPreferencesData(preferences)
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
end)


RegisterServerEvent('codem-elegant-hud:SaveDisplayHud')
AddEventHandler('codem-elegant-hud:SaveDisplayHud', function(toggle)
    local src = source
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = "venicehud",
            hide = toggle,
            cinematic = false,
            speedtype = "kmh",
            compassPos = "top",
            showcompass = true,

        }
    else
        preferences[identifier].hide = toggle
    end
    SaveToPreferencesData(preferences)
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
end)

RegisterServerEvent('codem-elegant-hud:ChangeHud')
AddEventHandler('codem-elegant-hud:ChangeHud', function(hud)
    local src = source
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = hud,
            hide = false,
            cinematic = false,
            speedtype = "kmh",
            compassPos = "top",
            showcompass = true,
        }
    else
        preferences[identifier].hud = hud
    end
    SaveToPreferencesData(preferences)
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
end)

RegisterServerEvent('codem-elegant-hud:SaveCompass')
AddEventHandler('codem-elegant-hud:SaveCompass', function(pos)
    local src = source
    local identifier = GetIdentifier(src)
    if preferences[identifier] == nil then
        preferences[identifier] = {
            hud = hud,
            hide = false,
            cinematic = false,
            speedtype = "kmh",
            compassPos = pos,
            showcompass = true,
        }
    else
        preferences[identifier].compassPos = pos
    end
    SaveToPreferencesData(preferences)
    TriggerClientEvent("codem-elegant-hud:GetPreferences", src, preferences[identifier])
end)