


------------------------------------------------------General--------------------------------------------------------
Config = {}
Config.speedUnit = "mph" -- Default speed unit - kmh or mph
Config.useLegacyFuel = true
Config.FuelExport = 'LegacyFuel'
Config.SeatBeltMinSpeed = 15.6464
Config.SeatBeltMaxSpeed = 55.6464
Config.HideRadarOnFoot = true  -- if true Hide the map when you're walking
Config.Framework = "newqb" -- newqb, oldqb, esx
Config.Voice = 2 -- 1 salty 2 pma 3 - mumble
Config.CommandHud = 'hud'
Config.PlayerandMoneyHud =true

------------------------------------------------------Keys--------------------------------------------------------

Config.RegisterKeyMapping = true  --- if true script uses RegisterKeyMapping system if false you can set keys from NotUseRegisterKeymappingCruiseKey
Config.rightindicator = "RIGHT" --- This will work even if RegisterKeyMapping is true or false
Config.leftindicator = "LEFT" --- This will work even if RegisterKeyMapping is true or false
Config.hazardlights = "DOWN"  --- This will work even if RegisterKeyMapping is true or false
Config.seatbeltkey = "b"   --- set this if RegisterKeymmaping is true
Config.cruisekey = "h"  -- set this if RegisterKeymmaping is true
Config.NotUseRegisterKeymappingCruiseKey = 303    -- set this if RegisterKeymapping is false  --U-- --- change key == https://docs.fivem.net/docs/game-references/controls/
Config.NotUseRegisterKeymappingSeatbeltKey = 323  -- set this if RegisterKeymapping is false --X-- --- change key == https://docs.fivem.net/docs/game-references/controls/

------------------------------------------------------Notify--------------------------------------------------------

Config.VeniceNotify =  true    --- if true use VeniceNotification or custom notfiy if false use esx shownotification
Config.VeniceUseNotify = function(text,time,type) TriggerEvent('codem-notification', text,time,type)  end -- Custom notification event
Config.Notify1 ={text = "Did you fasten your seat belt?", type = 'info', time = 5000 }   --
Config.Notify2 ={text ="You took off your seat belt", type = "info", time = 5000 }  --
Config.Notify3 = {text = "You have set the speed limit", type ="info" , time  = 5000}  --
Config.Notify4 = {text = "You have disabled the speed limit", type ="info" , time  = 5000}  ---


------------------------------------------------------Shared Objects--------------------------------------------------------

Config.ESXGetSharedObject = function()
    local esx = nil
    while esx == nil do
        TriggerEvent('esx:getSharedObject', function(obj) esx = obj end)
        Citizen.Wait(0)
    end
    return esx
end
Config.OldQBGetSharedObject = function()
    local QBCore = nil
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
    return QBCore
end

Config.NewQBGetSharedObject = function()
    return exports["qb-core"].GetCoreObject()
end



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

Config.GetStatus = function()
    Citizen.Wait(100)
    while not nuiReady do
        Citizen.Wait(0)
    end
    while true do

            if Config.Framework == "newqb" or Config.Framework == "oldqb"  then
                while QBCore == nil do
                    Citizen.Wait(0)
                end
                while QBCore.Functions.GetPlayerData() == nil do
                    Citizen.Wait(0)
                end
                while QBCore.Functions.GetPlayerData().metadata == nil do
                    Citizen.Wait(0)
                end
                local myhunger = QBCore.Functions.GetPlayerData().metadata["hunger"]
                local mythirst = QBCore.Functions.GetPlayerData().metadata["thirst"]
                local stress = QBCore.Functions.GetPlayerData().metadata["stress"]
                local hudStatus = Config.PlayerandMoneyHud
                SendNUIMessage({food = myhunger, water = mythirst,stress = stress,hudStatus=hudStatus})
            end
            if Config.Framework == "esx" then

                TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
                    TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                        TriggerEvent('esx_status:getStatus', 'thirst', function(stress)
                        local myhunger = hunger.getPercent()
                        local mythirst = thirst.getPercent()
                        local myStrees = stress.getPercent()
                        local hudStatus = Config.PlayerandMoneyHud

                        SendNUIMessage({food = myhunger, water = mythirst,stress = myStrees,hudStatus=hudStatus})
                        end)
                    end)
                end)
            end

        Citizen.Wait(7000)
    end
end

