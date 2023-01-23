function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num + 0.5 * mult)
end


function GetFrameWork()
    local object = nil
    if Config.Framework == "esx" then
        while object == nil do
            TriggerEvent('esx:getSharedObject', function(obj) object = obj end)
            Citizen.Wait(0)
        end
    end
    if Config.Framework == "newqb" then
        object = exports["qb-core"]:GetCoreObject()
    end
    if Config.Framework == "oldqb" then
        while object == nil do
            TriggerEvent('QBCore:GetObject', function(obj) object = obj end)
            Citizen.Wait(200)
        end
    end
    return object
end
local hudgoster = false
Citizen.CreateThread(function()

    frameworkObject = GetFrameWork()
    if Config.PlayerandMoneyHud then

     if Config.Framework == "esx" then
        Citizen.Wait(1000)
        while true do
             
                if frameworkObject.GetPlayerData() then
                    while frameworkObject.GetPlayerData().job == nil do
                        Citizen.Wait(0)
                    
                    end
             
                    SendNUIMessage({
                        job = frameworkObject.GetPlayerData().job.label
                    })
                     for k, v in pairs(frameworkObject.GetPlayerData().accounts) do
                       
                         if v.name == "money" then
                         
                             local money = v.money   
                                                                 
                             SendNUIMessage({
                                 money = money
                         
                             })
                          
                        end
                        if v.name == "bank" then
                             local bank = v.money

                             SendNUIMessage({
                             
                                 bank = bank
                             })
                         end
                     end
                                 
                   
                end
            
            Citizen.Wait(5000)
        end
     else
        while true do
            Citizen.Wait(0)
            if frameworkObject ~= nil then
                local Player = frameworkObject.Functions.GetPlayerData()
                if Player then
                    if Player.job ~= nil then
                                         
                    SendNUIMessage({
                        job = Player.job.label
                    })
                    end
                    if Player.money ~= nil then
                    
                        SendNUIMessage({
                          
                            money = Player.money.cash
                    
                        })
                        SendNUIMessage({
                          
                            bank = Player.money.bank
                    
                        })
                     
                    end
                end
            end
            Citizen.Wait(5000)
        end
     end
    
    end
end)

Citizen.CreateThread( function()

    while true do
        Citizen.Wait(1)
       
        local camRot = GetGameplayCamRot(0)
        heading = tostring(round(360.0 - ((camRot.z + 360.0) % 360.0)))

        if heading == '360' then heading = '0' end

        if heading ~= lastHeading then
            if IsPedInAnyVehicle(PlayerPedId()) then
                SendNUIMessage({  plyHeading = heading })
            else
                SendNUIMessage({  plyHeading = heading })
            end
        end
        lastHeading = heading
    end
end)

Citizen.CreateThread(function()
    DisplayRadar(false)

end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while true do
        Citizen.Wait(0)
        HideHudComponentThisFrame(6) -- VEHICLE_NAME
        HideHudComponentThisFrame(7) -- AREA_NAME
        HideHudComponentThisFrame(8) -- VEHICLE_CLASS
        HideHudComponentThisFrame(9) -- STREET_NAME
    end
end)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    if Config.HideRadarOnFoot then
        DisplayRadar(false)
    else
        DisplayRadar(true)
    end
end)


local toggleHud = true
local pedInVeh = false
local seatbeltIsOn = false
local cruiseIsOn = false
local cruiseSpeed = 999.0
local Zone = "No name."
nuiReady = false

local QBCore
local ESX

Citizen.CreateThread(function()

    if Config.Framework == "newqb" then
        QBCore = Config.NewQBGetSharedObject()
    elseif Config.Framework == "oldqb" then
        QBCore = Config.OldQBGetSharedObject()
    elseif Config.Framework == "esx" then
        ESX = Config.ESXGetSharedObject()
    end

end)



local zones = {
	["AIRP"] = "Los Santos International Airport",
	["ALAMO"] = "Alamo Sea",
	["ALTA"] = "Alta",
	["ARMYB"] = "Fort Zancudo",
	["BANHAMC"] = "Banham Canyon Dr",
	["BANNING"] = "Banning",
	["BEACH"] = "Vespucci Beach",
	["BHAMCA"] = "Banham Canyon",
	["BRADP"] = "Braddock Pass",
	["BRADT"] = "Braddock Tunnel",
	["BURTON"] = "Burton",
	["CALAFB"] = "Calafia Bridge",
	["CANNY"] = "Raton Canyon",
	["CCREAK"] = "Cassidy Creek",
	["CHAMH"] = "Chamberlain Hills",
	["CHIL"] = "Vinewood Hills",
	["CHU"] = "Chumash",
	["CMSW"] = "Chiliad Mountain State Wilderness",
	["CYPRE"] = "Cypress Flats",
	["DAVIS"] = "Davis",
	["DELBE"] = "Del Perro Beach",
	["DELPE"] = "Del Perro",
	["DELSOL"] = "La Puerta",
	["DESRT"] = "Grand Senora Desert",
	["DOWNT"] = "Downtown",
	["DTVINE"] = "Downtown Vinewood",
	["EAST_V"] = "East Vinewood",
	["EBURO"] = "El Burro Heights",
	["ELGORL"] = "El Gordo Lighthouse",
	["ELYSIAN"] = "Elysian Island",
	["GALFISH"] = "Galilee",
	["GOLF"] = "GWC and Golfing Society",
	["GRAPES"] = "Grapeseed",
	["GREATC"] = "Great Chaparral",
	["HARMO"] = "Harmony",
	["HAWICK"] = "Hawick",
	["HORS"] = "Diamond Casino And Resort",
	["HUMLAB"] = "Humane Labs and Research",
	["ISHEIST"] = "Cayo Perico",
	["JAIL"] = "Bolingbroke Penitentiary",
	["KOREAT"] = "Little Seoul",
	["LACT"] = "Land Act Reservoir",
	["LAGO"] = "Lago Zancudo",
	["LDAM"] = "Land Act Dam",
	["LEGSQU"] = "Legion Square",
	["LMESA"] = "La Mesa",
	["LOSPUER"] = "La Puerta",
	["MIRR"] = "Mirror Park",
	["MORN"] = "Morningwood",
	["MOVIE"] = "Richards Majestic",
	["MTCHIL"] = "Mount Chiliad",
	["MTGORDO"] = "Mount Gordo",
	["MTJOSE"] = "Mount Josiah",
	["MURRI"] = "Murrieta Heights",
	["NCHU"] = "North Chumash",
	["NOOSE"] = "N.O.O.S.E",
	["OCEANA"] = "Pacific Ocean",
	["PALCOV"] = "Paleto Cove",
	["PALETO"] = "Paleto Bay",
	["PALFOR"] = "Paleto Forest",
	["PALHIGH"] = "Palomino Highlands",
	["PALMPOW"] = "Palmer-Taylor Power Station",
	["PBLUFF"] = "Pacific Bluffs",
	["PBOX"] = "Pillbox Hill",
	["PROCOB"] = "Procopio Beach",
	["RANCHO"] = "Rancho",
	["RGLEN"] = "Richman Glen",
	["RICHM"] = "Richman",
	["ROCKF"] = "Rockford Hills",
	["RTRAK"] = "Redwood Lights Track",
	["SANAND"] = "San Andreas",
	["SANCHIA"] = "San Chianski Mountain Range",
	["SANDY"] = "Sandy Shores",
	["SKID"] = "Mission Row",
	["SLAB"] = "Stab City",
	["STAD"] = "Maze Bank Arena",
	["STRAW"] = "Strawberry",
	["TATAMO"] = "Tataviam Mountains",
	["TERMINA"] = "Terminal",
	["TEXTI"] = "Textile City",
	["TONGVAH"] = "Tongva Hills",
	["TONGVAV"] = "Tongva Valley",
	["VCANA"] = "Vespucci Canals",
	["VESP"] = "Vespucci",
	["VINE"] = "Vinewood",
	["WINDF"] = "Ron Alternates Wind Farm",
	["WVINE"] = "West Vinewood",
	["ZANCUDO"] = "Zancudo River",
	["ZP_ORT"] = "Port of South Los Santos",
	["ZQ_UAR"] = "Davis Quartz",
}

function GetZoneNameLabel(zoneName)
	if zones[zoneName] then
		return zones[zoneName]
	else
		return zoneName
	end
end

RegisterNUICallback('Ready', function()
    nuiReady = true


    SendNUIMessage({
        setid =  GetPlayerServerId(PlayerId()),
    })
    SendNUIMessage({
        hideonfoot =  Config.HideRadarOnFoot,
    })
end)


Citizen.CreateThread(function()
    while true do
        local position = GetEntityCoords(PlayerPedId())
        SendNUIMessage({streetName = GetZoneNameLabel(GetNameOfZone(position.x, position.y, position.z))})
        Citizen.Wait(2000)
    end
end)

local speedMultiplier = 3.6
Citizen.CreateThread(function()
    while not nuiReady do
        Citizen.Wait(0)
    end
    if Config.speedUnit == "kmh" then
        speedMultiplier = 3.6
        local kmh = 'kmh'
        SendNUIMessage({changeSpeedUnit = 'kmh'})
    elseif Config.speedUnit == "mph" then
        speedMultiplier = 2.236936
        local mph = 'mph'
        SendNUIMessage({changeSpeedUnit = 'mph'})
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local saat = GetClockHours()
        local min = GetClockMinutes()
        if saat < 10 then 
            saat = '0'..saat 
        end
        if min < 10 then 
            min = '0'..min 
        end
        SendNUIMessage({min = min, saat=saat})

    end
end)


Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Citizen.Wait(100)
        SetRadarZoom(1100)
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        SetBigmapActive(false, false)
    end
end)
Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
end)

local lastHealth = nil
local lastArmour = nil
local lastOxygen = nil

Citizen.CreateThread(function()
    Citizen.Wait(100)
    while not nuiReady do
        Citizen.Wait(0)
    end
    while true do
        if toggleHud == true then
            local player = PlayerPedId()
            local health = (GetEntityHealth(player) - 100)
            local armour = GetPedArmour(player)
            local oxygen = 0
            if IsEntityInWater(player) then
                oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
            else
                oxygen = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
            end

            if health ~= lastHealth or armour ~= lastArmour or oxygen ~= lastOxygen then
                SendNUIMessage({health = health, armour = armour, oxygen = oxygen})
                lastOxygen = oxygen
                lastHealth = health
                lastArmour = armour
            end
        end
        Citizen.Wait(376)
    end
end)

Citizen.CreateThread(function()
    Config.GetStatus()
end)



RegisterKeyMapping('seatbelt', 'Seat Bealt', 'keyboard', Config.seatbeltkey)
RegisterKeyMapping('cruise', 'Cruise Control', 'keyboard', Config.cruisekey)
RegisterKeyMapping('leftindicator', 'Left indicator', 'keyboard', Config.leftindicator)
RegisterKeyMapping('rightindicator', 'Right indicator', 'keyboard', Config.rightindicator)
RegisterKeyMapping('hazardlights', 'Hazard Lights', 'keyboard', Config.hazardlights)
RegisterKeyMapping('+handbrake', 'Handbrake', 'keyboard', "Space")
RegisterCommand("+handbrake", function()
    SendNUIMessage({handbrake = true})
end)


RegisterCommand(Config.CommandHud, function()
    SendNUIMessage({hudsettings = true})
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(0)
    insettings = true
    if Config.HideRadarOnFoot then
        while insettings do
            Citizen.Wait(0)
            DisplayRadar(false)
        end
    end

end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)
    insettings = false
end)
RegisterNUICallback("mph", function()
    TriggerServerEvent("codem-elegant-hud:ChangeSpeedType", "mph")
end)

RegisterNUICallback("kmh", function()

    TriggerServerEvent("codem-elegant-hud:ChangeSpeedType", "kmh")
end)

CinematicHeight = 0.2
CinematicModeOn = false
w = 0
function CinematicShow(bool)
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    CinematicModeOn = bool
    if bool then
        for i = CinematicHeight, 0, -1.0 do
            Wait(10)
            w = i
        end 
    else
        for i = 0, CinematicHeight, 1.0 do 
            Wait(10)
            w = i
        end
    end
end

CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do 
            Wait(1)
        end
    end
    while true do
        Wait(0)
        if w > 0 then
            BlackBars()
            DisplayRadar(0)
        end
    end
end)

function BlackBars()
    DrawRect(0.0, 0.0, 2.0, w, 0, 0, 0, 255)
    DrawRect(0.0, 1.0, 2.0, w, 0, 0, 0, 255)
end

RegisterNUICallback("cinematicmode", function()
    TriggerServerEvent("codem-elegant-hud:SaveCinematicMode", true)
end)

RegisterNUICallback("disablecinematicmode", function()
    TriggerServerEvent("codem-elegant-hud:SaveCinematicMode", false)
end)

RegisterNUICallback("hidehud", function()
    TriggerServerEvent("codem-elegant-hud:SaveDisplayHud", true)
end)
RegisterNUICallback("showhud", function()
    TriggerServerEvent("codem-elegant-hud:SaveDisplayHud", false)
end)
RegisterNUICallback("venicehud", function()
    TriggerServerEvent("codem-elegant-hud:ChangeHud", "venicehud")
end)

RegisterNUICallback("texthud", function()
    TriggerServerEvent("codem-elegant-hud:ChangeHud", "texthud")
end)

RegisterNUICallback("radialhud", function()
    TriggerServerEvent("codem-elegant-hud:ChangeHud", "radialhud")
end)

RegisterNUICallback("showcompass", function()
    TriggerServerEvent('codem-elegant-hud:SaveShowCompass', true)
end)

RegisterNUICallback("hidecompass", function()
    TriggerServerEvent('codem-elegant-hud:SaveShowCompass', false)
end)

RegisterCommand("-handbrake", function()
    SendNUIMessage({handbrake = false})
end)

local useIndicator = true 
RegisterNetEvent("codem-elegant-hud:UseIndicator")
AddEventHandler("codem-elegant-hud:UseIndicator", function(toggle)
    useIndicator = toggle
    if not toggle then
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(750)
        if useIndicator then
            local player = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(player, false)
            if vehicle ~= 0 then
                if GetVehicleIndicatorLights(vehicle) == 1 or GetVehicleIndicatorLights(vehicle) == 2 or GetVehicleIndicatorLights(vehicle) == 3 then
                    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) -- on
                end
            end
        end

    end
end)

local hazardlights = false
local leftindicator = false
local rightindicator = false
RegisterCommand("leftindicator", function()
    if useIndicator then
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        if vehicle ~= 0 then
            if GetVehicleIndicatorLights(vehicle) == 1 or GetVehicleIndicatorLights(vehicle) == 3 then
                SetVehicleIndicatorLights(vehicle, 1, false)
                SendNUIMessage({leftindicator = 'off'})
                leftindicator = false
            elseif GetVehicleIndicatorLights(vehicle) == 0 or  GetVehicleIndicatorLights(vehicle) == 2 then
                SetVehicleIndicatorLights(vehicle, 1, true)
                SendNUIMessage({leftindicator = 'on'})
                leftindicator = true
            end
            hazardlights = false
        end
    end

end)

RegisterCommand("rightindicator", function()
    if useIndicator then
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        if vehicle ~= 0 then
            if GetVehicleIndicatorLights(vehicle) == 3 or GetVehicleIndicatorLights(vehicle) == 2 then
                SetVehicleIndicatorLights(vehicle, 0, false)
                rightindicator = false
                SendNUIMessage({rightindicator = 'off'})
            elseif GetVehicleIndicatorLights(vehicle) == 0 or  GetVehicleIndicatorLights(vehicle) == 1 then
                SetVehicleIndicatorLights(vehicle, 0, true)
                SendNUIMessage({rightindicator = 'on'})
                rightindicator = true
    
            end
            hazardlights = false
        end

    end

end)

RegisterCommand("hazardlights", function()
    if useIndicator then
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        if vehicle ~= 0 then
            if not hazardlights then
                hazardlights = true
                SendNUIMessage({hazardlights = 'on'})
                SetVehicleIndicatorLights(vehicle, 0, false)
                SetVehicleIndicatorLights(vehicle, 1, false)
                SendNUIMessage({rightindicator = 'off'})
                SendNUIMessage({leftindicator = 'off'})
                SetVehicleIndicatorLights(vehicle, 0, true)
                SetVehicleIndicatorLights(vehicle, 1, true)
            else
                SendNUIMessage({hazardlights = 'off'})
                hazardlights = false
                SetVehicleIndicatorLights(vehicle, 0, false)
                SetVehicleIndicatorLights(vehicle, 1, false)
                if rightindicator and leftindicator then
                    SetVehicleIndicatorLights(vehicle, 0, true)
                    SetVehicleIndicatorLights(vehicle, 1, true)
                    SendNUIMessage({rightindicator = 'on'})
                    SendNUIMessage({leftindicator = 'on'})
    
                elseif rightindicator then
                    SetVehicleIndicatorLights(vehicle, 0, true)
                    SendNUIMessage({rightindicator = 'on'})
    
                elseif leftindicator then
                    SetVehicleIndicatorLights(vehicle, 1, true)
                    SendNUIMessage({leftindicator = 'on'})
                end
            end
        end
    end

end)

RegisterCommand('seatbelt', function()
    
    if pedInVeh == true and  Config.RegisterKeyMapping == true  then
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehicleClass = GetVehicleClass(vehicle)
        if vehicleClass ~= 13 and vehicleClass ~= 8 then
            seatbeltIsOn = not seatbeltIsOn
            SendNUIMessage({seated = seatbeltIsOn})
            PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
            if seatbeltIsOn == true then
                if Config.VeniceNotify == true then 
                
                    Config.VeniceUseNotify(Config.Notify1.text,Config.Notify1.time,Config.Notify1.type )
                else 
                
                ESX.ShowNotification(Config.Notify1.text)
                end
           
                SetFlyThroughWindscreenParams(Config.SeatBeltMaxSpeed, 2.2352, 0.0, 0.0)
                SetPedConfigFlag(PlayerPedId(), 32, false)
            
            else
                if Config.VeniceNotify == true then 
                    Config.VeniceUseNotify(Config.Notify2.text,Config.Notify1.time,Config.Notify1.type )
                    SetFlyThroughWindscreenParams(Config.SeatBeltMinSpeed, 2.2352, 0.0, 0.0)
                    SetPedConfigFlag(PlayerPedId(), 32, true)
                else
                    ESX.ShowNotification(Config.Notify2.text)
                    SetFlyThroughWindscreenParams(Config.SeatBeltMinSpeed, 2.2352, 0.0, 0.0)
                    SetPedConfigFlag(PlayerPedId(), 32, true)
                end                      
            end
        end
    end
end, false)



RegisterCommand('cruise', function()
    if Config.RegisterKeyMapping == true then
    local player = PlayerPedId()
    if pedInVeh == true then
        local vehicle = GetVehiclePedIsIn(player, false)
        if (GetPedInVehicleSeat(vehicle, -1) == player) then
            cruiseIsOn = not cruiseIsOn
            local currSpeed = GetEntitySpeed(vehicle)
            cruiseSpeed = currSpeed
            local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
            SetEntityMaxSpeed(vehicle, maxSpeed)
            if cruiseIsOn == true then
                if Config.VeniceNotify == true then 
                 
                    Config.VeniceUseNotify(Config.Notify3.text,Config.Notify3.time,Config.Notify3.type )
                else 

                ESX.ShowNotification(Config.Notify3.text)
                end
              
            else
                if Config.VeniceNotify == true then 
                 
                    Config.VeniceUseNotify(Config.Notify4.text,Config.Notify4.time,Config.Notify4.type )
                else 
                ESX.ShowNotification(Config.Notify4.text)
                end
              
            end
            SendNUIMessage({cruised = cruiseIsOn})
        else
            cruiseIsOn = false
        end
    end
    end
end, false)

Citizen.CreateThread(function()
    if Config.RegisterKeyMapping == false then
        local wait = 1000
        while true do   
            local player = PlayerPedId()
            if pedInVeh == true then            
                local vehicle = GetVehiclePedIsIn(player, false)
                if (GetPedInVehicleSeat(vehicle, -1) == player) then
                    wait = 1
                    if IsControlJustPressed(0, Config.NotUseRegisterKeymappingCruiseKey) then 
                        cruiseIsOn = not cruiseIsOn
                        local currSpeed = GetEntitySpeed(vehicle)
                        cruiseSpeed = currSpeed
                        local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
                        SetEntityMaxSpeed(vehicle, maxSpeed)                    
                        if cruiseIsOn == true then
                            if Config.VeniceNotify == true then 
                                Config.VeniceUseNotify(Config.Notify3.text,Config.Notify3.time,Config.Notify3.type )
                            else 
                                ESX.ShowNotification(Config.Notify3.text)
                            end
                        else
                            if Config.VeniceNotify == true then 
                                Config.VeniceUseNotify(Config.Notify4.text,Config.Notify4.time,Config.Notify4.type )
                            else 
                                ESX.ShowNotification(Config.Notify4.text)
                            end
                        end
                        SendNUIMessage({cruised = cruiseIsOn})
                    end
                else
                    cruiseIsOn = false
                end
            else
                wait = 1000
            end
            Citizen.Wait(wait)
        end
    end
end)

Citizen.CreateThread(function()
    if Config.RegisterKeyMapping == false then
        while true do 
            local wait = 1000
            if pedInVeh == true then
                local player = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(player, false)
                local vehicleClass = GetVehicleClass(vehicle)
                if vehicleClass ~= 13 and vehicleClass ~= 8 then
                    wait = 1
                    if IsControlJustPressed(0, Config.NotUseRegisterKeymappingSeatbeltKey ) then 
                        seatbeltIsOn = not seatbeltIsOn
                        SendNUIMessage({seated = seatbeltIsOn})
                        PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                        if seatbeltIsOn == true then
                            if Config.VeniceNotify == true then 
                                Config.VeniceUseNotify(Config.Notify1.text,Config.Notify1.time,Config.Notify1.type )
                            else 
                                ESX.ShowNotification(Config.Notify1.text)
                            end
                            SetFlyThroughWindscreenParams(Config.SeatBeltMaxSpeed, 2.2352, 0.0, 0.0)
                            SetPedConfigFlag(PlayerPedId(), 32, false)                        
                        else
                            if Config.VeniceNotify == true then 
                                Config.VeniceUseNotify(Config.Notify2.text,Config.Notify1.time,Config.Notify1.type )
                                SetFlyThroughWindscreenParams(Config.SeatBeltMinSpeed, 2.2352, 0.0, 0.0)
                                SetPedConfigFlag(PlayerPedId(), 32, true)
                            else
                                ESX.ShowNotification(Config.Notify2.text)
                                SetFlyThroughWindscreenParams(Config.SeatBeltMinSpeed, 2.2352, 0.0, 0.0)
                                SetPedConfigFlag(PlayerPedId(), 32, true)
                            end                      
                        end
                    end
                end
            else
                wait = 1000
            end
            Citizen.Wait(wait)
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        if seatbeltIsOn then
            DisableControlAction(0,75)
        end
        Citizen.Wait(5)
    end
end)


local insettings = false
Citizen.CreateThread(function()
    Citizen.Wait(100)
    local currSpeed = 0.0
    while not nuiReady do
        Citizen.Wait(0)
    end
    while true do
    
        local player = PlayerPedId()
        local position = GetEntityCoords(player)
        local vehicle = GetVehiclePedIsIn(player, false)
        
        if IsPedInAnyVehicle(player, false) then
            pedInVeh = true
            Citizen.Wait(1500)
            if not insettings  then
                DisplayRadar(true)
            end
            local motor = GetIsVehicleEngineRunning(vehicle)
            SendNUIMessage({ motor = motor})
        else
            local kimlik = GetPlayerServerId(NetworkGetEntityOwner(player))
          
            SendNUIMessage({showVehiclePart = false , kimlik = kimlik})
            pedInVeh = false
            cruiseIsOn = false
            seatbeltIsOn = false
            if not insettings and Config.HideRadarOnFoot then
                DisplayRadar(false)
            elseif not Config.HideRadarOnFoot then
                DisplayRadar(true)
            end
            SendNUIMessage({seated = seatbeltIsOn, cruised = cruiseIsOn})
        
        end
        if pedInVeh == true then
         
        
            local vehicleClass = GetVehicleClass(vehicle)
            if pedInVeh and GetIsVehicleEngineRunning(vehicle) and vehicleClass ~= 13 then
                local prevSpeed = currSpeed
                currSpeed = GetEntitySpeed(vehicle)			
                local motor = GetIsVehicleEngineRunning(vehicle)
    
                SetPedConfigFlag(PlayerPedId(), 32, true)
                 local fuel = 0
                 if Config.useLegacyFuel then
                     fuel = exports[Config.FuelExport]:GetFuel(vehicle)
                 else
                     fuel = GetVehicleFuelLevel(vehicle)
                 end
            
                local vhealth = GetEntityHealth(vehicle)
                local locked = true
                if GetVehicleDoorLockStatus(vehicle) == 1 or GetVehicleDoorLockStatus(vehicle) == 0 then locked = false end
              
                SendNUIMessage({showVehiclePart = true, motor = motor, fuel = fuel})
                if vehicleClass == 8 then
                    SendNUIMessage({hideseat = true})
                else
                    SendNUIMessage({hideseat = false})
                end
            end
        end
        Citizen.Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while not nuiReady do
        Citizen.Wait(0)
    end
    while true do 
        if pedInVeh then
            local player = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(player, true)
            local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(vehicle)
            local vehicleIsLightsOn
            if vehicleLights == 1 and vehicleHighlights == 0 then
                vehicleIsLightsOn = 'normal'
            elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
       
                vehicleIsLightsOn = 'high'
            else
                vehicleIsLightsOn = 'off'
            end
            SendNUIMessage({isiklar = vehicleIsLightsOn})
        end

        Citizen.Wait(350)
    end
end)
RegisterCommand('mouse',function()
    SetNuiFocus(true, true)
end)


Citizen.CreateThread(function()
    Citizen.Wait(100)
    while not nuiReady do
        Citizen.Wait(0)
    end
    while true do
        local sleepTime = 1000
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        if toggleHud == true and pedInVeh == true and vehicle then
            local currSpeed = GetEntitySpeed(vehicle)
            local speed = ("%.1d"):format(math.ceil(currSpeed * speedMultiplier)) 
            if tonumber(speed) > 0 then
                local rpm =  GetVehicleEngineHealth(vehicle)
                local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
                SendNUIMessage({speed = speed, rpm = rpm, maxSpeed = math.ceil(maxSpeed+20 * speedMultiplier)})
                sleepTime = 50
            else
                local rpm =  GetVehicleEngineHealth(vehicle)
                local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
                SendNUIMessage({speed = 0, rpm = rpm, maxSpeed = math.ceil(maxSpeed+20 * speedMultiplier)})
                sleepTime = 500
            end

        end
        Citizen.Wait(sleepTime)
    end
end)



RegisterNetEvent('SaltyChat_VoiceRangeChanged')
AddEventHandler('SaltyChat_VoiceRangeChanged', function(voiceRange, index, availableVoiceRanges) 


    SendNUIMessage({talkingRadius = index  + 1 })
 end)

RegisterNetEvent('SaltyChat_TalkStateChanged')
AddEventHandler('SaltyChat_TalkStateChanged', function(isTalking)
    SendNUIMessage({talking = isTalking})
end)


local checkTalkStatus = false
Citizen.CreateThread(function()
    Citizen.Wait(100)
    if Config.Voice == 2 or Config.Voice == 3 then
        while true do
            if NetworkIsPlayerTalking(PlayerId()) then
                if not checkTalkStatus then
                    checkTalkStatus = true
                    SendNUIMessage({talking = true})
                end
            else
                if checkTalkStatus then
                    checkTalkStatus = false
                    SendNUIMessage({talking = false})
                end
            end
            Citizen.Wait(300)
        end
    end
end)


RegisterNetEvent('pma-voice:setTalkingMode')
AddEventHandler('pma-voice:setTalkingMode', function(voiceMode) 
    SendNUIMessage({talkingRadius = voiceMode})
end)

RegisterNetEvent("mumble:SetVoiceData")
AddEventHandler("mumble:SetVoiceData", function(player, key, value) 
    if GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())) == player and key == 'mode' then
         SendNUIMessage({talkingRadius = value})
    end
end)


RegisterNUICallback("compass-onmap", function()
    TriggerServerEvent("codem-elegant-hud:SaveCompass", "onmap")
end)

RegisterNUICallback("compass-bottom", function()
    TriggerServerEvent("codem-elegant-hud:SaveCompass", "bottom")
end)
RegisterNUICallback("compass-top", function()
    TriggerServerEvent("codem-elegant-hud:SaveCompass", "top")
end)
RegisterNetEvent('codem-elegant-hud:GetPreferences')
AddEventHandler('codem-elegant-hud:GetPreferences', function(preferences)
    while not nuiReady do
        Citizen.Wait(0)
    end
    SendNUIMessage({preferences = preferences})
    if preferences.cinematic then
        if not CinematicModeOn then
            CinematicShow(true)
        end
    else
        if CinematicModeOn then
            CinematicShow(false)
        end
    end
    if preferences.speedtype == "kmh" then
        speedMultiplier = 3.6
    else
        speedMultiplier = 2.236936
    end

    if IsPedInAnyVehicle(PlayerPedId()) then
        SendNUIMessage({invehicle = true})
    else
        SendNUIMessage({invehicle = false})

    end
end)


local alreadyEntered = false
local first = true
local pauseActive = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(350)
        if IsPauseMenuActive() and not pauseActive then
            pauseActive = true
            SendNUIMessage({pauseactive = true})            
        end
        if not IsPauseMenuActive() and  pauseActive then
            pauseActive = false
            SendNUIMessage({pauseactive = false})            
        end
    end
end)


Citizen.CreateThread(function()
    while not nuiReady do
        Citizen.Wait(0)
    end
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) then
            if not alreadyEntered or first  then
                SendNUIMessage({invehicle = true})
                alreadyEntered = true
                first = false
                if Config.HideRadarOnFoot then
                    DisplayRadar(false)
                else
                    DisplayRadar(true)
            
                end
            end
        else
            if alreadyEntered or first then
                SendNUIMessage({invehicle = false})
                alreadyEntered = false
                first = false
                if Config.HideRadarOnFoot then
                    DisplayRadar(false)
                else
                    DisplayRadar(true)
                end
            end
        end
    end
end)