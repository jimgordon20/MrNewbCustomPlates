RegisterNetEvent("MrNewbCustomPlates:getPlate", function(data)
    local src = source
    local oldPlate = data.vehicle
    local newPlate = data.inputted1
    local entityid = data.entity

    if not newPlate then return NotifyPlayer(src, "No Plate Provided", "error") end

    if Config.Debug then print("Player id# "..src.." has changed a plate from ".."Old Plate "..oldPlate.." New Plate "..newPlate) end

    NotifyPlayer(src, "The license plate has been changed from "..oldPlate.." to "..newPlate.." ", "success")

    VerifyPlateOwnership(src, oldPlate, function(plateOwner)
        if not plateOwner then return NotifyPlayer(src, "You Dont Own This Vehicle.", "error") end

        VerifyPlateAvailable(newPlate, function(plateExists)
            if plateExists then return NotifyPlayer(src, "This plate already exists.", "error") end

            --if you use t1ger keys or mk uncomment the line below
            --if Config.Keys == "t1ger" then RemoveKeys(src, entityid, oldPlate, newPlate) end
            UpdateFrameworkPlate(newPlate, oldPlate)
            UpdateVehicleInventoryTrunkGlove(src, oldPlate, newPlate)
            TriggerClientEvent("MrNewbCustomPlates:setplatetoclient", -1, data)
            if Config.Logs then logs(src, " | Has changed plate from "..oldPlate.." to "..newPlate) end
            RemoveItemFromInventory(src)

            if Config.Keys then GiveKeys(src, entityid, oldPlate, newPlate) end
        end)
    end)
end)

RegisterNetEvent("MrNewbCustomPlates:server:VerifyOwnership", function(vehicle, plate)
    local src = source

    VerifyPlateOwnership(src, plate, function(plateOwner)
        if not plateOwner then return NotifyPlayer(src, "You Dont Own This Vehicle.", "error") end

        TriggerClientEvent("MrNewbCustomPlates:plateCustomization", src, vehicle, plate)
    end)
end)