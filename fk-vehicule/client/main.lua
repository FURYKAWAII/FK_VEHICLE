if Config.ESX == "new" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.ESX == "old" then
    ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)
end

OpenMenu = false
local mainMenu = RageUI.CreateMenu('Gestion', "Intéraction")
local subMenuLimitateur = RageUI.CreateSubMenu(mainMenu, "Limitateur", "Intéraction")
local subMenuPortes = RageUI.CreateSubMenu(mainMenu, "Portes", "Intéraction")
mainMenu.Closed = function()
    OpenMenu = false
end

etatinfo = false
etatgestion = false
etatmoteur = false

local kmValue = Config.KMH

local capot = {
    action = {
        '~g~Ouvrir~s~',
        '~r~Fermer~s~',
    },

    list = 1
}
local chest = {
    action = {
        '~g~Ouvrir~s~',
        '~r~Fermer~s~',
    },

    list = 1
}
local doors = {
    action = {
        '~b~Avant-Gauche~s~',
        '~b~Avant-Droite~s~',
        '~b~Arrière-Gauche~s~',
        '~b~Arrière-Droite~s~',
        '~b~Toutes les portières~s~',
    },

    list = 1
}
local windos = {
    action = {
        '~b~Avant-Gauche~s~',
        '~b~Avant-Droite~s~',
        '~b~Arrière-Gauche~s~',
        '~b~Arrière-Droite~s~',
        '~b~Toutes les fenêtres~s~',
    },

    list = 1
}

function GestionVehMenu()
    if OpenMenu then
        OpenMenu = false
        RageUI.Visible(mainMenu, false)
        return
    else
        OpenMenu = true
        RageUI.Visible(mainMenu, true)


        CreateThread(function()
            while OpenMenu do
                Wait(1)

                RageUI.IsVisible(mainMenu, function()

                        RageUI.Separator('~r~↓~s~ Menu Véhicule ~r~↓~s~')

                        RageUI.Checkbox("Informations du Véhicule", nil, etatinfo, {}, {
                            onChecked = function()
                                etatinfo = true
                            end,
                            onUnChecked = function()
                                etatinfo = false
                            end
                        })

                        if etatinfo == true then

                        RageUI.Separator("~b~↓~s~ Informations ~b~↓~s~")

                        local pedveh = GetVehiclePedIsIn(PlayerPedId(), false)
                        local vehfuel = GetVehicleFuelLevel(pedveh)
                        local vehtemp = GetVehicleEngineTemperature(pedveh)
                        local vehdoor = GetVehicleDoorLockStatus(pedveh)
                        local vehhealth = GetEntityHealth(pedveh) / 10
                        local vehplaque = GetVehicleNumberPlateText(pedveh)

                        if vehdoor == 1 then
                            RageUI.Separator("Status du véhicule : ~g~Ouvert")
                        else
                            RageUI.Separator("Status du véhicule : ~r~Fermé")
                        end

                        if vehhealth <= 10 then
                            RageUI.Separator("État du moteur : ~r~0 %")
                        elseif vehhealth <= 50 then
                            RageUI.Separator("État du moteur : ~o~"..math.ceil(vehhealth).." %")
                        elseif vehhealth >= 50 then
                            RageUI.Separator("État du moteur : ~g~"..math.ceil(vehhealth).." %")
                        end

                        if math.ceil(vehfuel) <= 50 then
                            RageUI.Separator("Niveau d'essence : ~o~"..math.ceil(vehfuel).." %")
                        elseif math.ceil(vehfuel) >= 50 then
                            RageUI.Separator("Niveau d'essence : ~g~"..math.ceil(vehfuel).." %")
                        elseif math.ceil(vehfuel) <= 10 then
                            RageUI.Separator("Niveau d'essence : ~r~"..math.ceil(vehfuel).." %")
                        end

                        RageUI.Separator("Température du moteur : ~g~"..math.ceil(vehtemp).."°C")
                        RageUI.Separator("Plaque du véhicule : ~b~"..(vehplaque).."")
                    end

                    RageUI.Checkbox("Gestions du Véhicule", nil, etatgestion, {}, {
                        onChecked = function()
                            etatgestion = true
                        end,
                        onUnChecked = function()
                            etatgestion = false
                        end
                    })

                    if etatgestion == true then

                        RageUI.Separator("~b~↓~s~ Gestion ~b~↓~s~")

                        RageUI.Checkbox("Couper le Moteur", nil, etatmoteur, {}, {
                            onChecked = function()
                                etatmoteur = true
                            end,
                            onUnChecked = function()
                                etatmoteur = false
                            end
                        })
    
                        if etatmoteur == true then
                            SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), false, false, true)
                            SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId()), true)
                        elseif etatmoteur == false then
                            SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), true, false, true)
                        end

                        RageUI.Button("Limitateur", nil, {RightLabel = "→→"}, true, {}, subMenuLimitateur)

                        RageUI.Button("Portes", nil, {RightLabel = "→→"}, true, {}, subMenuPortes)
                    end
                end)

                RageUI.IsVisible(subMenuLimitateur, function()

                    RageUI.Separator('~r~↓~s~ Menu Limitateur ~r~↓~s~')

                    RageUI.Button("~b~Vitesse Personnalisée", description, {}, true, {
                        onSelected = function()
                            local vitesseVroumVroum = KeyboardInput('Vitesse', '', 3, false)
                                if vitesseVroumVroum == nil then
                                    print('Value is NULL')
                                else
                                vitesse(vitesseVroumVroum)
                                end
                        end
                    })
                    RageUI.Button("~r~Désactivé", nil, {}, true, {
                        onSelected = function()
                                vitesse(0)
                        end
                    })
                    for k, value in pairs(kmValue) do
                        RageUI.Button("~g~" ..value.." KM/H", nil, {}, true, {
                            onSelected = function()
                                vitesse(value)
                            end
                        })
                    end

                end)

                RageUI.IsVisible(subMenuPortes, function() 

                    RageUI.Separator('~r~↓~s~ Menu Portes ~r~↓~s~')

                    RageUI.List('Gestion du capot', capot.action, capot.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                        if (Selected) then 
        
                            if Index == 1 then
                                SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 4, false, false)
        
                            elseif Index == 2 then
                                SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 4, false, false)
        
                        end
        
                    end
        
                       capot.list = Index;              
        
                    end)

                    RageUI.List('Gestion du coffre', chest.action, chest.list, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                        if (Selected) then 
        
                            if Index == 1 then
                                SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 5, false, false)
        
                            elseif Index == 2 then
                                SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 5, false, false)
        
                        end
        
                    end
        
                       chest.list = Index;              
        
                    end)

                    RageUI.List('Gestion des portières', doors.action, doors.list, 'Rappuyer pour fermer la portière', {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                        if (Selected) then 
        
                            if Index == 1 then
                                if not avantg then
                                    avantg = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 0, false, false)
                                elseif avantg then
                                    avantg = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 0, false, false)
                                end
                            end
        
                            if Index == 2 then
                                if not avantd then
                                    avantd = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 1, false, false)
                                elseif avantd then
                                    avantd = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 1, false, false)
                                end
                            end
        
                            if Index == 3 then
                                if not arrg then
                                    arrg = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 2, false, false)
                                elseif arrg then
                                    arrg = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 2, false, false)
                                end
                            end
        
                            if Index == 4 then
                                if not arrd then
                                    arrd = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 3, false, false)
                                elseif arrd then
                                    arrd = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 3, false, false)
                                end
                            end
        
                            if Index == 5 then
                                if not alldoors then
                                    alldoors = true
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 0, false, false)
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 1, false, false)
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 2, false, false)
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 3, false, false)
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 4, false, false)
                                    SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), 5, false, false)
        
                                elseif alldoors then
                                    alldoors = false
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 0, false, false)
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 1, false, false)
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 2, false, false)
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 3, false, false)
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 4, false, false)
                                    SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), 5, false, false)
                                end
                            end
                    end
        
                       doors.list = Index;              
        
                    end)

                    RageUI.List('Gestion des fenêtres', windos.action, windos.list, 'Rappuyer pour fermer la fenêtre', {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)

                        if (Selected) then 
        
                            if Index == 1 then
                                if not avantg then
                                    avantg = true
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 0) 
                                elseif avantg then
                                    avantg = false
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 0) 
                                end
                            end
        
                            if Index == 2 then
                                if not avantd then
                                    avantd = true
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                                elseif avantd then
                                    avantd = false
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                                end
                            end
        
                            if Index == 3 then
                                if not arrg then
                                    arrg = true
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                                elseif arrg then
                                    arrg = false
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                                end
                            end
        
                            if Index == 4 then
                                if not arrd then
                                    arrd = true
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
                                elseif arrd then
                                    arrd = false
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
                                end
                            end
        
                            if Index == 5 then
                                if not allw then
                                    allw = true
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 0)
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                                    RollDownWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
        
        
                                elseif allw then
                                    allw = false
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 0) 
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 1) 
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 2) 
                                    RollUpWindow(GetVehiclePedIsIn(PlayerPedId()), 3) 
        
                                end
                            end
                    end
        
                       windos.list = Index;              
        
                    end)
                end)

            end
        end)
    end
end

Keys.Register('F9', 'F9', 'Test', function()
    local Ped = PlayerPedId()

    if (IsPedInAnyVehicle(Ped)) then
        GestionVehMenu()
    else
        ESX.ShowNotification('Vous devez être dans un véhicule')
    end
end)

RegisterCommand("gv", function() 
    local Ped = PlayerPedId()

    if (IsPedInAnyVehicle(Ped)) then
        GestionVehMenu()
    else
        ESX.ShowNotification('Vous devez être dans un véhicule')
    end
end)