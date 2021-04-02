
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterServerEvent('prx_lychees:comprobarItem')
AddEventHandler('prx_lychees:comprobarItem', function(coord)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem('axe')

	if item.count >= 1 then
		local tree = coord
		TriggerClientEvent('prx_lychees:recolectarLychees', source, tree)
	else
		notification('No tienes un hacha, vete a  una tienda a comprarla.')
	end
end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end

RegisterServerEvent('prx_lychees:darLychees')
AddEventHandler('prx_lychees:darLychees', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local numero = math.random(4,6)
	xPlayer.addInventoryItem('lychee', numero)
end)


RegisterServerEvent('prx_lychees:procesarLychees')
AddEventHandler('prx_lychees:procesarLychees', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local numero = math.random(23,25)
	local numero2 = math.random(10, 12)
	local numeroDeLychees = xPlayer.getInventoryItem('lychee')
	if numeroDeLychees.count >= numero then
		xPlayer.removeInventoryItem('lychee', numero)
		xPlayer.addInventoryItem('lychee_lata', numero2)
	else
		notification('No tienes lychees para procesar')
	end
end)

RegisterServerEvent('prx_lychees:venderLychees')
AddEventHandler('prx_lychees:venderLychees', function(numero)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local numero_azar = math.random(15,17)
	local money = numero * numero_azar
	local numeroDeLychees = xPlayer.getInventoryItem('lychee_lata')
	if numeroDeLychees.count >= numero then
		xPlayer.removeInventoryItem('lychee_lata', numero)
		xPlayer.addMoney(money)
	else
		notification('No tienes lychees para vender')
	end
end)