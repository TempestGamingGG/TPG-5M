bMenuOpen = false

QBCore = exports['qb-core']:GetCoreObject()
local isLoggedIn = false
local PlayerJob = {}
local PlayerGang = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    SendNUIMessage({type = "refresh_accounts"})
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    SendNUIMessage({type = "refresh_accounts"})
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    PlayerGang = QBCore.Functions.GetPlayerData().gang
	PlayerJob = JobInfo
    SendNUIMessage({type = "refresh_accounts"})
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerJob = QBCore.Functions.GetPlayerData().job
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    PlayerGang = GangInfo
    SendNUIMessage({type = "refresh_accounts"})
end)


local BankControlPress = false
 local function BankControl()
    CreateThread(function()
        BankControlPress = true
        while BankControlPress do
            if IsControlPressed(0, 38) then
                exports['qb-core']:KeyPressed()
                ToggleUI()
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
                ToggleUI()
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
                    exports['qb-core']:DrawText(Lang:t('info.access_bank_key'),'left')
                    BankControl()
                else
                    BankControlPress = false
                    exports['qb-core']:HideText()
                end
            end)
        end
    end
end)


function ToggleUI()
    local charinfo = QBCore.Functions.GetPlayerData().charinfo
    bMenuOpen = not bMenuOpen

    if (not bMenuOpen) then
        SetNuiFocus(false, false)
    else
        QBCore.Functions.TriggerCallback("qb-banking:server:GetBankData", function(data, transactions)
            local PlayerBanks = json.encode(data)


            SetNuiFocus(true, true)
            SendNUIMessage({type = 'OpenUI', accounts = PlayerBanks, transactions = json.encode(transactions), name = charinfo.firstname.. " ".. charinfo.lastname})
        end)
    end
end

RegisterNUICallback("CloseATM", function()
    ToggleUI()
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end)

RegisterNUICallback("DepositCash", function(data, cb)
    if (not data or not data.account or not data.amount) then
        return
    end

    if (tonumber(data.amount) <= 0) then
        return
    end

    TriggerServerEvent("qb-banking:server:Deposit", data.account, data.amount, (data.note ~= nil and data.note or ""))
end)

RegisterNUICallback("WithdrawCash", function(data, cb)
    if (not data or not data.account or not data.amount) then
        return
    end

    if(tonumber(data.amount) <= 0) then
        return
    end

    TriggerServerEvent("qb-banking:server:Withdraw", data.account, data.amount, (data.note ~= nil and data.note or ""))
end)

RegisterNUICallback("TransferCash", function(data, cb)
    if (not data or not data.account or not data.amount or not data.target) then
        return
    end

    if(tonumber(data.amount) <= 0) then
        return
    end

    if(tonumber(data.target) <= 0) then
        return
    end

    TriggerServerEvent("qb-banking:server:Transfer", data.target, data.account, data.amount, (data.note ~= nil and data.note or ""))
end)



--// Net Events \\--
RegisterNetEvent("qb-banking:client:Notify")
AddEventHandler("qb-banking:client:Notify", function(type, msg)
    if (bMenuOpen) then
        SendNUIMessage({type = 'notification', msg_type = type, message = msg})
    end
end)

RegisterNetEvent("qb-banking:client:UpdateTransactions")
AddEventHandler("qb-banking:client:UpdateTransactions", function(transactions)
    if (bMenuOpen) then

        SendNUIMessage({type = 'update_transactions', transactions = json.encode(transactions)})

        QBCore.Functions.TriggerCallback("qb-banking:server:GetBankData", function(data, transactions)
            local PlayerBanks = json.encode(data)
            SendNUIMessage({type = "refresh_balances", accounts = PlayerBanks})
        end)
    end
end)
