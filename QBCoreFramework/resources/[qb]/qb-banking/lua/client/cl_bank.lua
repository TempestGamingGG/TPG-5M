local notified = false
local lastNotified = 0

local banks = {
	{name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
	{name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
	{name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
	{name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
	{name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
	{name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
	{name="Bank", id=106, x=241.610, y=225.120, z=106.286},
	{name="Bank", id=108, x=1175.064, y=2706.643, z=38.094}
}


RegisterNetEvent("qb-banking:client:ExtNotify")
AddEventHandler("qb-banking:client:ExtNotify", function(msg)
	if (not msg or msg == "") then return end

	QBCore.Functions.Notify(msg)
end)

--[[ Show Things ]]--
Citizen.CreateThread(function()
	for k,v in ipairs(banks) do
	  local blip = AddBlipForCoord(v.x, v.y, v.z)
	  SetBlipSprite(blip, v.id)
	  SetBlipDisplay(blip, 4)
	  SetBlipScale  (blip, 0.7)
	  SetBlipColour (blip, 2)
	  SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
	  AddTextComponentString(tostring(v.name))
	  EndTextCommandSetBlipName(blip)
	end
end)


RegisterNetEvent('qb-banking:client:bank:openUI')
AddEventHandler('qb-banking:client:bank:openUI', function() -- this one bank from target models
	if not bMenuOpen then
		TriggerEvent('animations:client:EmoteCommandStart', {"ATM"})

		QBCore.Functions.Progressbar("atm", "Opening Bank", 4500, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			ToggleUI()
		end, function()
			QBCore.Functions.Notify('Canceled', 'warning')
			TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		end)
	end
end)
RegisterNetEvent('qb-banking:client:atm:openUI')
AddEventHandler('qb-banking:client:atm:openUI', function() -- this opens ATM
	if not bMenuOpen then
		TriggerEvent('animations:client:EmoteCommandStart', {"ATM"})

		QBCore.Functions.Progressbar("atm", "Opening ATM", 4500, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			ToggleUI()
		end, function()
			QBCore.Functions.Notify('Canceled', 'warning')
			TriggerEvent('animations:client:EmoteCommandStart', {"c"})
		end)
	end
end)


local BankControlPress = false
 local function BankControl()
    CreateThread(function()
        BankControlPress = true
        while BankControlPress do
            if IsControlPressed(0, 38) then
                exports['qb-core']:KeyPressed()
                TriggerEvent('qb-banking:client:bank:openUI')
            end
            Wait(0)
        end
    end)
end

CreateThread(function()
    if Config.UseTarget then
        for k, v in pairs(Config.Zones) do
            exports["qb-target"]:AddBoxZone("Bank_"..k, v.position, v.length, v.width, {
                name = "Bank_"..k,
                heading = v.heading,
                minZ = v.minZ,
                maxZ = v.maxZ
            }, {
                options = {
                    {
                        type = "client",
                        event = "qb-banking:client:bank:openUI",
                        icon = "fas fa-university",
                        label = "Access Bank",
                    }
                },
                distance = 1.5
            })
        end
    else
        local bankPoly = {}
        for k, v in pairs(Config.BankLocations) do
            bankPoly[#bankPoly+1] = BoxZone:Create(vector3(v.x, v.y, v.z), 1.5, 1.5, {
                heading = -20,
                name="bank"..k,
                debugPoly = false,
                minZ = v.z - 1,
                maxZ = v.z + 1,
            })
            local bankCombo = ComboZone:Create(bankPoly, {name = "bankPoly"})
            bankCombo:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['qb-core']:DrawText(('[E] Open Bank'),'left')
                    BankControl()
                else
                    BankControlPress = false
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end)