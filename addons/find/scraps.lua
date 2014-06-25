
--[[ 
windower.register_event('unhandled command', function(command, ...) 
	local param = L{...}
	command = command and command:lower() or 'help'
	
	if command == 'track' then
	
	elseif command1 == 'help' then
		windower.add_to_chat(17, addon.name' v'..addon.version..' commands:')
		windower.add_to_chat(17, '//track [options]')
		windower.add_to_chat(17, '    arg1')
		windower.add_to_chat(17, '    arg2')
		windower.add_to_chat(17, '    help   - Displays this help text')
		windower.add_to_chat(17, ' ')
		windower.add_to_chat(17, 'AutoMA will only automate casting if your status is "Engaged".  Otherwise it will always fire a single spell.')
		windower.add_to_chat(17, 'To start auto casting without commands use the key:  Ctrl+d')
		windower.add_to_chat(17, 'To stop auto casting in the same manner:  Atl+d')
	end
end)
reference code from itemizer

--]]

--[[damnit... 
windower.register_event('addon command', function(command1, ...)
	local args = L{...}
	command1 = command1 and command1:lower() or 'help'
	
	--#find
    if command1 == 'find'
		if first_pass then 
			first_pass = false
			windower.send_ipc_message('find update')
			windower.send_command('wait 0.05;find '..table.concat({...},' '))
		else
			first_pass = true
			local query  = L{}
			local export = nil
			--[ [#obsolete used to remove the findall command before it was assigned to command1
			-- removes the first parameter in the list
			while args:length() > 0 and args[1]:match('^[:!]%a+$') do
				query:append(args:remove(1))
			end
			--] ]
			-- this assumes the only args is -export
			if args:length() > 0 then
				export = args[args:length()]:match('^--export=(.+)$') or args[args:length()]:match('^-e(.+)$')

				if export ~= nil then
					export = export:gsub('%.csv$', '')..'.csv'

					args:remove(args:length())

					if export:match('['..('\\/:*?"<>|'):escape()..']') then
						export = nil

						error('The filename cannot contain any of the following characters: \\ / : * ? " < > |')
					end
				end

				query:append(args:concat(' '))
			end
			
			search(query, export)
		end
	elseif command1 == 'track' then
	
	elseif command1 == 'help' then
		windower.add_to_chat(17, addon.name' v'..addon.version..' commands:')
		windower.add_to_chat(17, '//find [options]')
		windower.add_to_chat(17, '    arg1')
		windower.add_to_chat(17, '    arg2')
		windower.add_to_chat(17, '    help   - Displays this help text')
		windower.add_to_chat(17, ' ')
		windower.add_to_chat(17, 'AutoMA will only automate casting if your status is "Engaged".  Otherwise it will always fire a single spell.')
		windower.add_to_chat(17, 'To start auto casting without commands use the key:  Ctrl+d')
		windower.add_to_chat(17, 'To stop auto casting in the same manner:  Atl+d')
	end
end)
--]]

			arg_count = string.pcount(param,'($%b{})') --not needed
			arg_clip_pos = (string.find(param, '${') -1)--not needed
			arg_start_str = string.slice(param, 1, arg_clip_pos)--not needed


--[=[	
	--[==[
		local bag = param:remove(#param)
		local item_name = param:concat(' ')
		local search = command == 'get' and bag or 'inventory'

		local id = res.items:name(windower.wc_match-{item_name})
		if id:length() == 0 then
			id = res.items:name_full(windower.wc_match-{item_name})
			if id:length() == 0 then
				log('Unknown item')
				return
			end
		end

		local index = table.with[2](res.bags, 'english', string.imatch-{bag})
		if not index then
			error('Unknown bag: ' .. bag)
			return
		end

		for slot, item in pairs(windower.ffxi.get_items()[search]) do 
			if id[item.id] then 
				windower.ffxi[command .. '_item'](index, slot)
				return
			end 
		end

	]==]
	if w:length == dissected_params:length then -- token is the last part of the string, process and return text to display
			return_text = return_text .. w:token_builder
			goto processing_complete
		elseif mark == 1 -- token is at the start of the string. 
			return_text = return_text .. w:token_builder  -- process token and attach results to return_text.
		end
		elseif w:length == dissected_params:length
		end
		 v = v+1
		 print(w)
		end
		print(#tokens) --:map(string.length)
		--print(break_points)
		i = 1
		k = 1
		--while k < string.len(params) do
			if tokens[i] then
				--print(break_points[i])
				i = i+1
			end
			--[===[ I need to get the length of each token, then use that to determine the start and end points of each token
				from there I check is the start point of the first token is equal to 1 (beginning of the param line) and if so I 
				skip to the end of token 1 to start splicing the display text.  If it is not equal to 1 I start splicing at 1 
				until the beginning of  token 1.  From there I splice between each set of tokens until the last token.  I test
				if the end of the last token is == to #param (last character of param).  If so we end, otherwise we splice from 
				end of last token to end of param.
				Build a string using the token_builder funtion
				]===]
		--end
		::processing_complete::
	return return_text
	
	
		windower.add_to_chat(17, 'AutoMA  v'..version..'commands:')
		windower.add_to_chat(17, '//ama [options]')
		windower.add_to_chat(17, '    start|s            - Starts auto casting of a single spell')
		windower.add_to_chat(17, '    stop|x             - Stops auto casting')
		windower.add_to_chat(17, '    cast|c             - Casts the set spell once')
		windower.add_to_chat(17, '    delay|d  <seconds> - Sets the wait time in seconds after spell is cast')
		windower.add_to_chat(17, '    spell|sp  <spell>  - Sets the spell to cast')
		windower.add_to_chat(17, '    help|h             - Displays this help text')
		windower.add_to_chat(17, '    verbose|v <1|0>    - Enables/Disables displaying of some status messages')
		windower.add_to_chat(17, ' ')
		windower.add_to_chat(17, 'AutoMA will only automate casting if your status is "Engaged".  Otherwise it will always fire a single spell.')
		windower.add_to_chat(17, 'To start auto casting without commands use the key:  Ctrl+d')
		windower.add_to_chat(17, 'To stop auto casting in the same manner:  Atl+d')
]=]

--[===[

ids = T{}
for item in resources:it() do
    ids[item.name:lower()] = item.id 
    ids[item.name_log:lower()] = item.id 
end
]===]
--basic loop test
	print(global_test_counter)
	global_test_counter = global_test_counter + 1
	
--escapes a string for pattern matching
escapedString = unknownString:escape():gsub('%a', function(char) return string.format("[%s%s]", char:lower(), char:upper()) end)
-- example: $free = %$[fF][rR][eE][eE]