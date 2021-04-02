local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local recolectando = false
local reiniciado = true


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
      
Citizen.CreateThread(function()

    for _, info in pairs(Config.blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Config.arboles) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.arboles[k].x, Config.arboles[k].y, Config.arboles[k].z)

            if dist <= 2.0 then
                if Config.arboles[k].used == false then
                    hintToDisplay('Pulsa ~INPUT_CONTEXT~ para recolectar ~r~lychees')
                
                    if IsControlJustPressed(0, Keys['E']) then -- "E"
                        if recolectando == false then
                            ComprobarRecoleccion(k)
                        end
                    end
                else
                    hintToDisplay('Tienes que esperar para volver a recolectar este árbol')
                end

            end
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.Venta) do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Venta[k].x, Config.Venta[k].y, Config.Venta[k].z)

        if dist <= 100.0 then
        
            -- Marker (START)
            DrawMarker(1, Config.Venta[k].x, Config.Venta[k].y, Config.Venta[k].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5001, 255, 246, 0, 200, 0, 0, 0, 0)
            -- Marker (END)
        end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.Procesado) do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Procesado[k].x, Config.Procesado[k].y, Config.Procesado[k].z)

        if dist <= 100.0 then
        
            -- Marker (START)
            DrawMarker(1, Config.Procesado[k].x, Config.Procesado[k].y, Config.Procesado[k].z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.5001, 255, 246, 0, 200, 0, 0, 0, 0)
            -- Marker (END)
        end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Config.Procesado) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Procesado[k].x, Config.Procesado[k].y, Config.Procesado[k].z+1)

            if dist <= 0.9 then

                        hintToDisplay('Pulsa ~INPUT_CONTEXT~ para procesar los ~r~lychees')
                
                        if IsControlJustPressed(0, Keys['E']) then -- "E"
                            ProcesarLychees()
                        end
                 

            end
        end
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Config.Venta) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z,  Config.Venta[k].x, Config.Venta[k].y, Config.Venta[k].z+1)

            if dist <= 0.9 then

                        hintToDisplay('Pulsa ~INPUT_CONTEXT~ para vender los ~r~lychees')
                
                        if IsControlJustPressed(0, Keys['E']) then -- "E"
                            VenderLychees()
                        end
                 

            end
        end
    end
end)

function ProcesarLychees()
    exports['progressBars']:startUI(1000, "Procesando Lychees...")
    Citizen.Wait(1000)
    TriggerServerEvent('prx_lychees:procesarLychees')
end

function VenderLychees()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cuanto',
  {
    title = ('¿ Cuantos Lychees quieres vender ?')
  },
  function(data, menu)
    local amount = tonumber(data.value)
    if amount == nil then
      ESX.ShowNotification('Cantidad no valida')
    else
      menu.close()
      TriggerServerEvent('prx_lychees:venderLychees', amount)
    end
  end,
  function(data, menu)
    menu.close()
  end)
end





function ComprobarRecoleccion(arbol)
    local coord = arbol
    TriggerServerEvent('prx_lychees:comprobarItem', coord)
end

RegisterNetEvent('prx_lychees:recolectarLychees')
AddEventHandler('prx_lychees:recolectarLychees', function(tree)
    local arbolActual = tree
    recolectando = true
    PlayAnim(arbolActual)
end)

function startAnim(lib, anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, true, true, true)
    end)
end

function PlayAnim(arbolAct)
    Citizen.CreateThread(function()
        startAnim('amb@world_human_hammering@male@base', 'base')
        exports['progressBars']:startUI(3000, "Recolectando Lychees...")
        Citizen.Wait(3000)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('prx_lychees:darLychees')
        recolectando = false
        for k in pairs(Config.arboles) do
            k = arbolAct
            Config.arboles[k].used = true
            Citizen.Wait(800)
        Config.arboles[k].used = false
        end
    end)
end


