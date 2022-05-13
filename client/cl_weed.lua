local QBCore = exports['qb-core']:GetCoreObject()
local Completed = {}

exports['qb-target']:AddTargetModel(`prop_weed_01`, {
	options = {
		{
			type = "client",
			action = function(entity)
                if not Completed[entity] then
					QBCore.Functions.Progressbar("picking_bud_1", "Picking Weed..", 10000, false, true, {
						disableMovement = true,
						disableCarMovement = false,
						disableMouse = false,
						disableCombat = false,
					}, {
						animDict = "mini@repair",
						anim = "fixing_a_player",
						flags = 8,
					}, {}, {}, function()
						StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
						LocalPlayer.state:set("inv_busy", false, true)
						TriggerServerEvent('QBCore:Server:AddItem', 'weed_wet', 1)
						TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["weed_wet"], "add")
						QBCore.Functions.Notify("You Picked a plant", "success")
						Completed[entity] = true
                    	return true
					end, function()
						StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
						LocalPlayer.state:set("inv_busy", false, true)
						QBCore.Functions.Notify("Cancelled..", "error")
						Completed[entity] = false
                    	return false
					end)

                else
                    QBCore.Functions.Notify("Already picked this plant", "error")
                    return false
                end
            end,
			icon = "fas fa-circle",
			label = "Pick Weed",
			canInteract = function(entity)
                return not Completed[entity]
            end,
		},
	},
	distance = 2.5
})

exports['qb-target']:AddBoxZone("weeddrying",vector3(-113.0726, -11.14904, 69.51), 1.2, 1.2, {
	name = "weeddrying",
	heading = 135,
	debugPoly = false,
	minZ = 69.51,
	maxZ = 70.74,
}, {
	options = {
		{
			type = "client",
			action = function()
				QBCore.Functions.TriggerCallback('tnj-weedpicking:server:getWetBud', function(HasItems)
					if HasItems then
						QBCore.Functions.Progressbar("drying_bud_1", "Drying Wet Weed Plant..", 10000, false, true, {
							disableMovement = true,
							disableCarMovement = false,
							disableMouse = false,
							disableCombat = false,
						}, {
							animDict = "mini@repair",
							anim = "fixing_a_player",
							flags = 8,
						}, {}, {}, function()
							StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
							LocalPlayer.state:set("inv_busy", false, true)
							TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['weed_wet'], 'remove')
							TriggerServerEvent('QBCore:Server:RemoveItem', 'weed_wet', 1)
							TriggerServerEvent('QBCore:Server:AddItem', 'weed_bud', 1)
							TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["weed_bud"], "add")
							QBCore.Functions.Notify("You dried a wet weed plant", "success")
						end, function()
							StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
							LocalPlayer.state:set("inv_busy", false, true)
							QBCore.Functions.Notify("Cancelled..", "error")
						end)
					else
						QBCore.Functions.Notify("You dont have a wet weed plant..", "error")
					end
				end)
			end,
			icon = "fas fa-cannabis",
			label = "Dry Weed",
		}
	},
	distance = 2.5
})
