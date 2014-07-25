windower.send_command('alias g11_m3g15 input /follow <t>;')
windower.send_command('alias g11_m3g17 input /follow <p1>;')
--[[
return {
    ['Alt+d'] = 'input /deliverybox',                 -- 
    ['Alt+x'] = 'input /sendpost',                 -- 
    ['Alt+k'] = 'input /logout',                 -- 
}
--]]

BLM = {
	['name'] = 'Blackmage',
	['Ctrl+1'] = 'printset',
	['Alt+2'] = 'input /ma "Bind" <t>',
	['Alt+0'] = 'input /echo BLM set',
	['Ctrl+3'] = JA,
}
JA = {
	['name'] = 'JA',
	['Ctrl+1'] = 'printset',
	['Alt+0'] = 'input /echo JA set',
}

return {
	['name'] = 'TOP',
    ['Alt+d'] = 'input /deliverybox',                 -- 
    ['Alt+x'] = 'input /sendpost',                 -- 
    ['Alt+k'] = 'input /logout',                 -- 
	['Ctrl+0'] = BLM,
	['Ctrl+1'] = 'printset',
}