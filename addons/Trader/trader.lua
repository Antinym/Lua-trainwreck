_addon.command = 'trade' 

packets = require('packets') 

trade_request = packets.new('outgoing', 0x032) 
trade_accept = packets.new('outgoing', 0x33, {Type = 0}) 
trade_confirm = packets.new('outgoing', 0x33, {Type = 2}) 

whitelist = L{
	'Jahya',
	'Guinear',
	'Varina',
	'Gumby',
	'Morella',
	'Lainey',
	'Daulphi',
	'Kaivalya',
	'Bah',
	'Jahy',
	'Icky',
	'Psy',
	'Gears',
}

windower.register_event('addon command', function(name)
 local mob = name and windower.ffxi.get_mob_by_name(name) or windower.ffxi.get_mob_by_target('t') 
	if mob then 
		trade_request['Target ID'] = mob.id
		trade_request['Target Index'] = mob.index 
		packets.inject(trade_request)
	end
end) 

windower.register_event('incoming chunk', function(id, data)
	if id == 0x021 then
		local request = packets.parse('incoming',data)
		trader_name = windower.ffxi.get_mob_by_id(request['Player']).name
		if whitelist:contains(trader_name) then
			packets.inject(trade_accept)
		end
	end
	if id == 0x022 then
		local request = packets.parse('incoming',data)
		if request['Type'] == 2 then
			packets.inject(trade_confirm)
		end
	end
end)