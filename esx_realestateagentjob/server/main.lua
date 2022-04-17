TriggerEvent('esx_phone:registerNumber', 'realestateagent', _U('clients'), false, false)
TriggerEvent('esx_society:registerSociety', 'realestateagent', _U('realtors'), 'society_realestateagent', 'society_realestateagent', 'society_realestateagent', {type = 'private'})

RegisterServerEvent('esx_realestateagentjob:revoke')
AddEventHandler('esx_realestateagentjob:revoke', function(property, owner)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'realestateagent' then
		TriggerEvent('esx_property:removeOwnedPropertyIdentifier', property, owner)
	else
	end
end)

RegisterServerEvent('sazs:Ouvert')
AddEventHandler('sazs:Ouvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Agence immobilière', '~r~Annonce', '~b~L\'Agence immobilière vient d\'ouvrir c\'est porte !', 'CHAR_MICHAEL', 8)
	end
end)

RegisterServerEvent('immo:Fermer')
AddEventHandler('immo:Fermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Agence immobilière', '~r~Annonce', '~b~L\'Agence immobilière  est désormais fermer.', 'CHAR_MICHAEL', 8)
	end
end)


RegisterServerEvent('esx_realestateagentjob:sell')
AddEventHandler('esx_realestateagentjob:sell', function(target, property, price)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

	if xPlayer.job.name ~= 'realestateagent' then
		return
	end

	if xTarget.getMoney() >= price then
		xTarget.removeMoney(price)

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
			account.addMoney(price)
		end)
	
		TriggerEvent('esx_property:setPropertyOwned', property, price, false, xTarget.identifier)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('client_poor'))
	end
end)

RegisterServerEvent('esx_realestateagentjob:rent')
AddEventHandler('esx_realestateagentjob:rent', function(target, property, price)
	local xPlayer = ESX.GetPlayerFromId(target)

	TriggerEvent('esx_property:setPropertyOwned', property, price, true, xPlayer.identifier)
end)

ESX.RegisterServerCallback('esx_realestateagentjob:getCustomers', function(source, cb)
	TriggerEvent('esx_ownedproperty:getOwnedProperties', function(properties)
		local xPlayers  = ESX.GetExtendedPlayers()
		local customers = {}

		for i=1, #properties, 1 do
			for j=1, #xPlayers, 1 do
				local xPlayer = xPlayers[j]

				if xPlayer.identifier == properties[i].owner then
					table.insert(customers, {
						name           = xPlayer.name,
						propertyOwner  = properties[i].owner,
						propertyRented = properties[i].rented,
						propertyId     = properties[i].id,
						propertyPrice  = properties[i].price,
						propertyName   = properties[i].name,
						propertyLabel  = properties[i].label
					})
				end
			end
		end

		cb(customers)
	end)
end)


RegisterServerEvent('mrw_prop:Save')
AddEventHandler('mrw_prop:Save', function(name, label, entering, exit, inside, outside, ipl, isSingle, isRoom, isGateway, roommenu, price)
    local x_source = source

    MySQL.Async.fetchAll("SELECT name FROM properties WHERE name = @name", {

   	   ['@name'] = name,

    }, 
    function(result)
        if result[1] ~= nil then 
       	   TriggerClientEvent('esx:showNotification', x_source, 'Ce nom éxiste déja !')
       	else 
       	   Insert(x_source, name, label, entering, exit, inside, outside, ipl, isSingle, isRoom, isGateway, roommenu, price)   
        end 
    end)
end)

function Insert(x_source, name, label, entering, exit, inside, outside, ipl, isSingle, isRoom, isGateway, roommenu, price)
    MySQL.Async.execute('INSERT INTO properties (name, label ,entering ,`exit`,inside,outside,ipls,is_single,is_room,is_gateway,room_menu,price) VALUES (@name,@label,@entering,@exit,@inside,@outside,@ipls,@isSingle,@isRoom,@isGateway,@roommenu,@price)',
		{
			['@name'] = name,
			['@label'] = label,
			['@entering'] = entering,
			['@exit'] = exit,
			['@inside'] = inside,
			['@outside'] = outside,
			['@ipls'] = ipl,
			['@isSingle'] = isSingle,
			['@isRoom'] = isRoom,
			['@isGateway'] = isGateway,
			['@roommenu'] = roommenu,
			['@price'] = price,

		}, 
		function (rowsChanged)
			TriggerClientEvent('esx:showNotification', x_source, 'Propriété bien enregistré')
		end
	)
end


RegisterServerEvent('Rayan:createhouse')
AddEventHandler('Rayan:createhouse', function(NameandLabel, x, y, z, namehouse)
	local xPlayer = ESX.GetPlayerFromId(source)
	local NomDuMec = xPlayer.getName()
	SendDiscordLogs("Nouvelle demande de propriété", '__Auteur:__ '..NomDuMec..'\n__Position:__  '..x..', '..y..', '..z..'\n__Nom & Label:__ '..namehouse, 16744192)
end)

function SendDiscordLogs(name,message,color)
    local DiscordWebHook = Config.WebHook
	local embeds = {
		{
			["title"] = "**".. name .."**",
            ["description"] = message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "Lawis",
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "lawis Logs",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end