DNC = {
	['Alt+2'] = 'input /ja "Curing Waltz III" <me>',
	['Alt+3'] = 'input /ja "Healing Waltz" <me>',
    ['Alt+4'] = 'input /ja "Box Step" <me>',
    ['Alt+5'] = 'input /ja "Quickstep" <me>',
    ['Alt+6'] = 'input /ja "Stutter Step" <me>',
    ['Alt+7'] = 'input /ja "Drain Samba" <me>',
    ['Alt+8'] = 'input /ja "Drain Samba II" <me>',
    ['Alt+9'] = 'input /ja "Haste Samba" <me>',
	['Ctrl+1'] = 'input /ja "Violent Flourish" <t>',
	['Ctrl+2'] = 'input /ja "Animated Flourish" <t>',
	['Ctrl+3'] = 'input /ja "Desperate Flourish" <t>',
	['Ctrl+4'] = 'input /ja "Reverse Flourish" <t>',
	['Ctrl+5'] = 'input /ja "Curing Waltz" <t>',
	['Ctrl+6'] = 'input /ja "Curing Waltz II" <t>',
	['Ctrl+7'] = 'input /ja "Curing Waltz III" <t>',
	['Ctrl+8'] = 'input /ja "Healing Waltz" <t>',
	['Ctrl+9'] = 'input /ja "Divine Waltz" <me>',
}

JA = {
    ['Alt+2'] = DNC,                -- Goes to DNC sub table
    ['Alt+4'] = 'input /ja "Sneak Attack" <me>',
    ['Alt+5'] = 'input /ja "Trick Attack" <me>',
    ['Alt+6'] = 'input /ja "Assassin\'s Charge" <me>',
    ['Alt+8'] = 'input /ja "Feint" <t>',
    ['Alt+9'] = 'input /ja "Bully" <t>',
    ['Ctrl+2'] = 'input /ja "Mug" <t>',
    ['Ctrl+3'] = 'input /ja "Despoil" <t>',
}

Magic = {
}

WS = {
    ['Alt+4'] = 'input /ja "Sneak Attack" <me>',
    ['Alt+5'] = 'input /ja "Trick Attack" <me>',
    ['Alt+7'] = 'input /ws "Extenterator" <t>',
    ['Alt+10'] = 'input /ws "Aeolian Edge" <t>',
}

return {
	['Alt+1'] = DNC,
    ['Alt+2'] = JA,                 -- Goes to JA sub table
    ['Alt+3'] = WS,                 -- Goes to WS sub table
}