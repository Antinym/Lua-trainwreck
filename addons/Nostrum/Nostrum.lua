--[[Copyright © 2014, trv
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Nostrum nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL trv BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.--]]

_addon.name = 'Nostrum'
_addon.author = 'trv'
_addon.version = '2.0.0'
_addon.commands = {'Nostrum','nos',}

packets=require('packets')
require('tables')
require('strings')
require('variables')
require('helperfunctions')
require('sets')
require('lists')
config = require('config')

local defaults={
    text={
        buttons={
            color={a=255,r=255,g=255,b=255},
            visible=true
            },
        name={
            color={a=255,r=255,g=255,b=255},
            visible=true
            },
        tp={
            color={a=255,r=255,g=255,b=255},
            visible=true
            },
        hp={
            color={a=255,r=255,g=255,b=255},
            visible=true
            },
        mp={
            color={a=255,r=255,g=255,b=255},
            visible=true
            },
        hpp={
            color={a=255,r=255,g=255,b=255},
            visible=true
            },
        na={
            color={a=255,r=255,g=255,b=255},
            visible=true
            },
        buffs={
            color={a=255,r=255,g=255,b=255},
            visible=true}
            },
    primitives={
        buttons={
            color={a=0, r=0, g=0, b=0},
                },
        highlight={
            color={a=100, r=255, g=255, b=255},
            },
        curaga_buttons={
            color={a=0, r=0,g=0, b=0},
            },
        background={color={a=100, r=0, g=0, b=0},
            },
        hp_bar={
            green={a=176, r=1, g=100, b=14},
            yellow={a=176, r=255,g=255,b=0},
            orange={a=176, r=255, g=100, b=1},
            red={a=176, r=255, g=0, b=0},
            visible=true
            },
        mp_bar={
            color={a=100, r=149, g=212, b=255},
            },
        hp_bar_background={
            color={a=200, r=0, g=0, b=0},
            },
        na_buttons={
            color={a=0, r=255, g=255, b=255},
            },
        buff_buttons={
            color={a=0, r=255, g=255, b=255},
            },
        },
    window={x_offset=0,y_offset=0,},
    profiles={
        default={
    ["Cure"]=true,["CureII"]=true,["CureIII"]=true,["CureIV"]=true,["CureV"]=true,["CureVI"]=true,
    ["Curaga"]=true,["CuragaII"]=true,["CuragaIII"]=true,["CuragaIV"]=true,["CuragaV"]=true,
    ["Sacrifice"]=false,["Erase"]=true,["Paralyna"]=true,["Silena"]=true,["Blindna"]=true,
    ["Poisona"]=true,["Viruna"]=true,["Stona"]=true,["Cursna"]=true,
    ["Haste"]=true,["HasteII"]=false,["Flurry"]=false,["FlurryII"]=false,["Protect"]=false,["Shell"]=false,["ProtectII"]=false,["ShellII"]=false,
    ["ProtectIII"]=false,["ShellIII"]=false,["ProtectIV"]=false,["ShellIV"]=false,["ProtectV"]=true,["ShellV"]=true,
    ["Refresh"]=false,["RefreshII"]=false,["Regen"]=false,["RegenII"]=false,["RegenIII"]=false,
    ["RegenIV"]=true,["RegenV"]=false,["PhalanxII"]=false,["Adloquium"]=false,["AnimusAugeo"]=false,["AnimusMinuo"]=false,["Embrava"]=false,
        },
    },
}
_defaults = config.load(defaults)
settings.text.buttons.color=_defaults.text.buttons.color
settings.text.buttons.visible=_defaults.text.buttons.visible
settings.text.name.color=_defaults.text.name.color
settings.text.name.visible=_defaults.text.name.visible
settings.text.tp.color=_defaults.text.tp.color
settings.text.tp.visible=_defaults.text.tp.visible
settings.text.hp.color=_defaults.text.hp.color
settings.text.hp.visible=_defaults.text.hp.visible
settings.text.mp.color=_defaults.text.mp.color
settings.text.mp.visible=_defaults.text.mp.visible
settings.text.hpp.color=_defaults.text.hpp.color
settings.text.hpp.visible=_defaults.text.hpp.visible
settings.text.na.color=_defaults.text.na.color
settings.text.na.visible=_defaults.text.na.visible
settings.text.buffs.color=_defaults.text.buffs.color
settings.text.buffs.visible=_defaults.text.buffs.visible
settings.primitives.buttons.color=_defaults.primitives.buttons.color
settings.primitives.highlight.color=_defaults.primitives.highlight.color
settings.primitives.curaga_buttons.color=_defaults.primitives.curaga_buttons.color
settings.primitives.background.color=_defaults.primitives.background.color
settings.primitives.mp_bar.color=_defaults.primitives.mp_bar.color
settings.primitives.hp_bar_background.color=_defaults.primitives.hp_bar_background.color
settings.primitives.na_buttons.color=_defaults.primitives.na_buttons.color
settings.primitives.buff_buttons.color=_defaults.primitives.buff_buttons.color
settings.primitives.hp_bar.green=_defaults.primitives.hp_bar.green
settings.primitives.hp_bar.yellow=_defaults.primitives.hp_bar.yellow
settings.primitives.hp_bar.orange=_defaults.primitives.hp_bar.orange
settings.primitives.hp_bar.red=_defaults.primitives.hp_bar.red
settings.primitives.hp_bar.visible=_defaults.primitives.hp_bar.visible
settings.profiles=_defaults.profiles
require('logger')
_settings=settings.profiles.default
count_cures(_settings)
count_buffs(_settings)
count_na(_settings)

-----------------------------------------------graphic-----------------------------------------------

function build_macro()
    x_start=settings.window.x_res-1-_defaults.window.x_offset
    y_start=settings.window.y_res-h-1-_defaults.window.y_offset

    prim_simple("BG1",settings.primitives.background,x_start-(_cures+_curagas)*(w+1)-153,y_start-party[1].n*(h+1)+h,(_cures+_curagas)*(w+1)+1,party[1].n*(h+1)+1)
    prim_simple("info1",settings.primitives.hp_bar_background,x_start-152,y_start-party[1].n*(h+1)+h,152,party[1].n*(h+1)+1)
    macro[1]:add('BG1')
    for j=party[1].n,1,-1 do
        local s = tostring(position_lookup[party[1][j]])
        prim_simple("phpp" .. s,settings.primitives.hp_bar,x_start-151,y_start,150/100*stat_table[party[1][j]].hpp,h)
        local color = choose_color(stat_table[party[1][j]].hpp)
        windower.prim.set_color("phpp".. s,settings.primitives.hp_bar[color].a,settings.primitives.hp_bar[color].r,settings.primitives.hp_bar[color].g,settings.primitives.hp_bar[color].b)
        prim_simple("pmpp" .. s,settings.primitives.mp_bar,x_start-151,y_start+19,150/100*stat_table[party[1][j]].mpp,5)
        text_simple("tp" .. s, settings.text.tp, x_start-151, y_start+11, stat_table[party[1][j]].tp)
        text_simple("name" .. s, settings.text.name, x_start-151, y_start-3, prepare_names(stat_table[party[1][j]].name))
        text_simple("hpp" .. s, settings.text.hpp, x_start, y_start-4, stat_table[party[1][j]].hpp)
        text_simple("hp" .. s, settings.text.hp, x_start-40, y_start-3, stat_table[party[1][j]].hp)
        text_simple("mp" .. s, settings.text.mp, x_start-40, y_start+11, stat_table[party[1][j]].mp)
        prims_by_layer[position_lookup[party[1][j]]]:extend({"phpp" .. s,"pmpp" .. s})
        texts_by_layer[position_lookup[party[1][j]]]:extend({"tp" .. s,"name" .. s,"hpp" .. s,"hp" .. s,"mp" .. s})
        block_num=12

        for i=6,1,-1 do
            if _settings[options.cures[i]] then 
                local s = options.cures[i] .. tostring(position_lookup[party[1][j]])
                block_num=block_num-1
                prim_simple('p' .. s,settings.primitives.buttons,x_start-(12-block_num)*(w+1)+1-153,y_start,w,h)
                text_simple(s,settings.text.buttons, x_start-(12-block_num)*(w+1)+1+((w-font_widths[options.aliases[options.cures[i]]])/2)-153, y_start, options.aliases[options.cures[i]])
                prims_by_layer[position_lookup[party[1][j]]]:append('p' .. s)
                texts_by_layer[position_lookup[party[1][j]]]:append(s)
                macro[1]:add('p' .. s)
                macro[1]:add(s)
            end
        end

        for i=11,7,-1 do
            if _settings[options.curagas[i]] then
                local s = options.curagas[i] .. tostring(position_lookup[party[1][j]])
                block_num=block_num-1
                prim_simple('p' .. s,settings.primitives.curaga_buttons,x_start-(12-block_num)*(w+1)+1-153,y_start,w,h)
                text_simple(s,settings.text.buttons, x_start-(12-block_num)*(w+1)+1+((w-font_widths[options.aliases[options.curagas[i]]])/2)-153, y_start, options.aliases[options.curagas[i]])
                prims_by_layer[position_lookup[party[1][j]]]:append('p' .. s)
                texts_by_layer[position_lookup[party[1][j]]]:append(s)
                macro[1]:add('p' .. s)
                macro[1]:add(s)
            end
        end

    y_start=y_start-(h+1)

    end
    
    prim_simple("target_background",settings.primitives.hp_bar_background,x_start-152,prim_coordinates.y['info1']-52,152,32)
    text_simple("target_name", settings.text.name, x_start-151, prim_coordinates.y['info1']-50,'')
    windower.text.set_font_size("target_name11", 13)
    prim_simple("target",settings.primitives.hp_bar,x_start-151,prim_coordinates.y['info1']-50,150,30)
    text_simple("targethpp",settings.text.tp,  x_start-151, prim_coordinates.y['info1']-34, '0')
    local color = choose_color(100)
    windower.prim.set_color("target",settings.primitives.hp_bar[color].a,settings.primitives.hp_bar[color].r,settings.primitives.hp_bar[color].g,settings.primitives.hp_bar[color].b)
    misc_hold_for_up.prims:append("target_background")
    misc_hold_for_up.prims:append("target")
    misc_hold_for_up.texts:append("target_name")
    misc_hold_for_up.texts:append("targethpp")
    prim_simple("pmenu",settings.primitives.hp_bar_background,x_start-152,prim_coordinates.y['info1']-20,152,20)
    text_simple("menu",settings.text.name, x_start-94, prim_coordinates.y['info1']-18, 'menu')
    misc_hold_for_up.prims:append("pmenu")
    misc_hold_for_up.texts:append("menu")

    if _na~=0 then
        prim_simple("BGna",settings.primitives.background,x_start-33*_na-153,y_start-11,(_na)*(33)+1,34)
        misc_hold_for_up.prims:append("BGna")
        macro[1]:add("BGna")
    end

    block_num=0

    for i=1,options.na['n'] do
        if _settings[options.na[i]] then
            prim_simple('p' .. options.na[i],settings.primitives.na_buttons,x_start-33*(block_num+1)-1-151,y_start-10,32,32)
            img_simple(options.na[i]..'i',windower.windower_path.."\\plugins\\icons\\spells\\"..options.images[options.na[i]]..'.png',x_start-33*(block_num+1)-152,y_start-10)
            text_simple(options.na[i], settings.text.na, x_start-33*(block_num+1)-152, y_start-10, options.aliases[options.na[i]])
            misc_hold_for_up.texts:append(options.na[i])
            misc_hold_for_up.prims:extend({options.na[i]..'i','p' .. options.na[i]})
            windower.text.set_bg_color(options.na[i], 50, 0, 0, 0)
            windower.text.set_bg_visibility(options.na[i], true)
            block_num=block_num+1
            macro[1]:add(options.na[i])
            macro[1]:add(options.na[i]..'i')
            macro[1]:add('p' .. options.na[i])
            windower.text.set_stroke_color(options.na[i], 255, 0, 0, 0)
            windower.text.set_stroke_width(options.na[i], 1)
        end
    end

    y_start=y_start-34

    if _buffs~=0 then
        prim_simple("BGbuffs",settings.primitives.background,x_start-33*_buffs-153,y_start-11,(_buffs)*(33)+1,34)
        misc_hold_for_up.prims:append("BGbuffs")
        macro[1]:add("BGbuffs")
    end

    block_num=0

    for i=1,options.buffs['n'] do
        if _settings[options.buffs[i]] then
            prim_simple('p' .. options.buffs[i],settings.primitives.buff_buttons,x_start-33*(block_num+1)-152,y_start-10,32,32)
            img_simple(options.buffs[i]..'i',windower.windower_path.."\\plugins\\icons\\spells\\"..options.images[options.buffs[i]]..'.png',x_start-33*(block_num+1)-152,y_start-10)
            text_simple(options.buffs[i], settings.text.buffs, x_start-33*(block_num+1)-152, y_start-11, options.aliases[options.buffs[i]])
            misc_hold_for_up.texts:append(options.buffs[i])
            misc_hold_for_up.prims:extend({options.buffs[i]..'i','p' .. options.buffs[i]})
            windower.text.set_bg_color(options.buffs[i], 50, 0, 0, 0)
            windower.text.set_bg_visibility(options.buffs[i], true)
            block_num=block_num+1
            macro[1]:add(options.buffs[i])
            macro[1]:add(options.buffs[i]..'i')
            macro[1]:add('p' .. options.buffs[i])
            windower.text.set_stroke_color(options.buffs[i], 255, 0, 0, 0)
            windower.text.set_stroke_width(options.buffs[i], 1)
        end
    end

    y_start=prim_coordinates.y['BG1']-100

    for k=2,3 do
        if party[k].n ~= 0 then
            prim_simple("BG"..tostring(k),settings.primitives.background,x_start-(_cures)*(w+1)-153,y_start-party[k].n*(h+1)+h,_cures*(w+1)+1,party[k].n*(h+1)+1)
            prim_simple("info"..tostring(k),settings.primitives.hp_bar_background,x_start-152,y_start-party[k].n*(h+1)+h,152,party[k].n*(h+1)+1)
            macro[k]:add("BG"..tostring(k))
        end
        for j=party[k].n,1,-1 do
            local n = 6*k+1-j
            local s = tostring(n)
            prim_simple("phpp" .. s,settings.primitives.hp_bar,x_start-151,y_start,150/100*stat_table[party[k][j]].hpp,h)
            local color = choose_color(stat_table[party[k][j]].hpp)
            windower.prim.set_color("phpp" .. n,settings.primitives.hp_bar[color].a,settings.primitives.hp_bar[color].r,settings.primitives.hp_bar[color].g,settings.primitives.hp_bar[color].b)
            prim_simple("pmpp" .. s,settings.primitives.mp_bar,x_start-151,y_start+19,150/100*stat_table[party[k][j]].mpp,5)
            text_simple("tp" .. s, settings.text.tp, x_start-151, y_start+11,stat_table[party[k][j]].tp)
            text_simple("name" .. s, settings.text.name, x_start-151, y_start-3, prepare_names(stat_table[party[k][j]].name))
            text_simple("hpp" .. s, settings.text.hpp, x_start, y_start-4, stat_table[party[k][j]].hpp)
            text_simple("hp" .. s, settings.text.hp, x_start-40, y_start-3, stat_table[party[k][j]].hp)
            text_simple("mp" .. s, settings.text.mp, x_start-40, y_start+11,stat_table[party[k][j]].mp)
            prims_by_layer[position_lookup[party[2][j]]]:extend({"phpp" .. s,"pmpp" .. s})
            texts_by_layer[position_lookup[party[2][j]]]:extend({"tp" .. s,"name" .. s,"hpp" .. s,"hp" .. s,"mp" .. s})

            block_num=12

            for i=11,1,-1 do
                if _settings[options.cures[i]] then 
                    local s = options.cures[i] .. s
                    block_num=block_num-1
                    prim_simple('p' .. s,settings.primitives.buttons,x_start-(12-block_num)*(w+1)+1-153,y_start,w,h)
                    text_simple(s, settings.text.buttons, x_start-(12-block_num)*(w+1)+1+((w-font_widths[options.aliases[options.cures[i]]])/2)-153, y_start, options.aliases[options.cures[i]])
                    prims_by_layer[position_lookup[party[2][j]]]:append('p' .. s)
                    texts_by_layer[position_lookup[party[2][j]]]:append(s)
                    macro[k]:add('p' .. s)
                    macro[k]:add(s)
                end
            end
            
            y_start=y_start-(h+1)

        end

        y_start=y_start-10

    end
end

windower.register_event('load', 'login', function()
    coroutine.sleep(2)
    alliance_keys = {'p5', 'p4', 'p3', 'p2', 'p1', 'p0', 'a15', 'a14', 'a13', 'a12', 'a11', 'a10', 'a25', 'a24', 'a23', 'a22', 'a21', 'a20'}
    party_from_memory = windower.ffxi.get_party()
    player_id = windower.ffxi.get_player().id
    alliance = {}
    position_lookup = {}
    stat_table = {}
    party = {[1]=L{},[2]=L{},[3]=L{}}

    for i=1,18 do
        local pkey = alliance_keys[i]
        if party_from_memory[pkey] and party_from_memory[pkey].mob then
            alliance[i] = party_from_memory[pkey].mob.id
            position_lookup[alliance[i]] = i
            stat_table[alliance[i]]={
                hp = party_from_memory[pkey].hp,
                mp = party_from_memory[pkey].mp,
                mpp = party_from_memory[pkey].mpp,
                hpp = party_from_memory[pkey].hpp,
                tp = party_from_memory[pkey].tp,
                name = party_from_memory[pkey].name,
                }
        end
    end

    for i=6,1,-1 do
        if alliance[i] then
            party[1]:append(alliance[i])
        end
    end

    for i=12,7,-1 do
        if alliance[i] then
            party[2]:append(alliance[i])
        end
    end

    for i=18,13,-1 do
        if alliance[i] then
            party[3]:append(alliance[i])
        end
    end
    build_macro()
    define_active_regions()

end)

windower.register_event('logout', wrecking_ball)

windower.register_event('addon command', function(...)
    local args = T{...}
    if #args < 1 or args[1]:lower() == "help" then
        print('help:Prints a list of these commands in the console.')
        print('refresh(r): Compares the macro\'s current party structures to the party structure in memory.')
        print('hide(h): Toggles the macro\'s visibility.')
        print('cut(c): Trims the macro down to size, removing blank spaces.')
      elseif args[1]:lower() == "hide" or args[1]:lower() == 'h' then
        toggle_visibility()
    elseif args[1]:lower() == "cut" or args[1]:lower() == 'c' then
        trim_macro()
    elseif args[1]:lower() == "refresh" or args[1]:lower() == 'r' then
        compare_alliance_to_memory()
    end

end)

windower.register_event('keyboard', function(dik,flags,blocked)
    if blocked == 32 then return end
    if dik == 15 or dik == 210 or dik == 28 then
        if flags then
            coroutine.sleep(.02)
            local target = windower.ffxi.get_mob_by_target('t')
            if target then update_target(target.index) end
        end
    end
end)

windower.register_event('mouse', function(type, x, y, delta, blocked)
    if blocked or hide then
        return
    end
    local hide_
    if type == 0 then
        for i=1,regions do
            if (y>b[i] and y<t[i]) and (x>l[i] and x<r[i]) then
                if not macro_visibility[i] then
                    toggle_macro_visibility(i)
                end
                local p = 'p' .. macro_order[region_map[i]][math.ceil((x-l[i])/30)] .. tostring(6*i + 1 - math.ceil((y-b[i])/25))
                hover(p)
            else
                if i == 1 then
                    if y>b[4] and y<t[4]+2 and x>l[4] and x<r[4] then
                        if not macro_visibility[1] then
                            toggle_macro_visibility(1)
                        end
                        local p = 'p' .. macro_order[region_map[4]][math.ceil((x-l[4])/33)]
                        hover(p)
                        return
                    elseif y>b[5] and y<t[5]+1 and x>l[5] and x<r[5] then
                        if not macro_visibility[1] then
                            toggle_macro_visibility(1)
                        end
                        local p = 'p' .. macro_order[region_map[5]][math.ceil((x-l[5])/33)]
                        hover(p)
                        return
                    end
                end
                if macro_visibility[i] then
                    toggle_macro_visibility(i)
                end
            end
        end
        
    elseif type == 1 then
        for i=1,regions do
            if y>b[i] and y<t[i] then
                if x>l[i] and x<r[i] then
                    determine_response(x,i,30,y)
                elseif x>l[i+5] and x<r[i+5] then
                    windower.send_command('input /target' .. stat_table[party[i][math.ceil((y-b[i])/25)]].name)
                else
                    return
                end
                
                dragged = true
                return true
            end
        end
        
        if y>b[4] and y<t[4] and x>l[4] and x<r[4] then
            determine_response(x,4,33)
            dragged = true
            return true
        elseif y>b[5] and y<t[5] and x>l[5] and x<r[5] then
            determine_response(x,5,33)
            dragged = true
            return true
        end
    elseif type == 2 then 
        if dragged then
            dragged = false
            return true
        end
    elseif type==4 then
        for i=1,regions do
            if y>b[i] and y<t[i] then
                if x>l[i+5] and x<r[i+5] then
                    windower.send_command('input /ma '..'"'..spell_default..'" '.. stat_table[party[i][math.ceil((y-b[i])/25)]].name)
                else
                    log(spell_default)
                    return
                end
            end
        end
    
        if y>b[4] and y<t[4] and x>l[4] and x<r[4] then
            spell_default = xml_to_lua[macro_order[region_map[4]][math.ceil((x-l[4])/33)]]
        elseif y>b[5] and y<t[5] and x>l[5] and x<r[5] then
            spell_default = xml_to_lua[macro_order[region_map[5]][math.ceil((x-l[5])/33)]]
        end

    end
end)

windower.register_event('outgoing chunk', function(id,data)
    if id == 0x015 then
        local packet = packets.parse('outgoing', data)
        local target = packet['Target Index']
        update_target(target)
    elseif id == 0x00D then
        is_zoning = true
        if not is_hidden then
            for key in pairs(nos_saved_prims) do
                if prim_coordinates.visible[key] then
                    windower.prim.set_visibility(key,false)
                end
            end
            for key in pairs(nos_saved_texts) do
                if text_coordinates.visible[key] then
                    windower.text.set_visibility(key,false)
                end
            end
        end
    elseif id == 0x00C then
        if not is_hidden then
            for key in pairs(nos_saved_prims) do
                windower.prim.set_visibility(key,prim_coordinates.visible[key])
            end
            for key in pairs(nos_saved_texts) do
                windower.text.set_visibility(key,text_coordinates.visible[key])
            end
        end
        coroutine.sleep(10)
        is_zoning = false
    end
end)

windower.register_event('incoming chunk', function(id, data)
    if id == 0x00E then
        local packet = packets.parse('incoming', data)
        local index = packet['Index']
        if prim_coordinates.visible['target'] and last_index == index then
            local hpp = packet['HP %']
            if last_hpp ~= hpp and hpp~=0 then windower.prim.set_size("target",150/100*hpp,30) end
                if hpp~=0 and math.floor(hpp/25) ~= math.floor(last_hpp/25) then
                    local color=choose_color(hpp)
                    windower.prim.set_color("target",settings.primitives.hp_bar[color].a,settings.primitives.hp_bar[color].r,settings.primitives.hp_bar[color].g,settings.primitives.hp_bar[color].b)
                end
        end
    elseif id == 0x0DF then
        local packet = packets.parse('incoming', data)
        local id = packet['ID']
        if not position_lookup[id] then return end
        to_update:clear()
        if stat_table[id].hp ~= packet['HP'] then
            stat_table[id].hp = packet['HP']
            to_update:append('hp')
        end
        if stat_table[id].mp ~= packet['MP'] then
            stat_table[id].mp = packet['MP']
            to_update:append('mp')
        end
        if stat_table[id].tp ~= packet['TP'] then
            stat_table[id].tp = packet['TP']
            to_update:append('tp')
        end
        if stat_table[id].hpp ~= packet['HPP'] then
            if math.floor(stat_table[id].hpp/25) ~= math.floor(packet['HPP']/25) then
                local color=choose_color(packet['HPP'])
                windower.prim.set_color('phpp'..position_lookup[id],settings.primitives.hp_bar[color].a,settings.primitives.hp_bar[color].r,settings.primitives.hp_bar[color].g,settings.primitives.hp_bar[color].b)
            end
            stat_table[id].hpp = packet['HPP']
            to_update:append('hpp')
            windower.prim.set_size('phpp'..position_lookup[id],150/100*stat_table[id]['hpp'],h)
        end
        if stat_table[id].mpp ~= packet['MPP'] then
            stat_table[id].mpp = packet['MPP']
            windower.prim.set_size('pmpp'..position_lookup[id],150/100*stat_table[id]['mpp'],5)
        end
        
        update_macro_data(id,to_update)
    elseif id == 0x0DD then
        local packet = packets.parse('incoming',data)
        coroutine.yield()
        local zone=packet['Zone']
        local id = packet['ID']
        if not position_lookup[id] then
            return
        end
        if zone ~= 0 then
            if not out_of_zone[id] then
                zero_dark_party(position_lookup[id],0)
                out_of_zone:add(id)
                seeking_information:add(id)
            end
        elseif is_zoning or seeking_information[packet['ID']] then
                to_update:clear()
                stat_table[id].hp = packet['HP']
                to_update:append('hp')
                stat_table[id].mp = packet['MP']
                to_update:append('mp')
                stat_table[id].tp = packet['TP']
                to_update:append('tp')
                if math.floor(stat_table[id].hpp/25) ~= math.floor(packet['HP%']/25) then --windower doesn't have to set the color if the boolean is false
                    local color=choose_color(packet['HP%'])
                    windower.prim.set_color('phpp'..position_lookup[id],settings.primitives.hp_bar[color].a,settings.primitives.hp_bar[color].r,settings.primitives.hp_bar[color].g,settings.primitives.hp_bar[color].b)
                end
                stat_table[id].hpp = packet['HP%']
                to_update:append('hpp')
                windower.prim.set_size('phpp'..position_lookup[id],150/100*stat_table[id]['hpp'],h)
                stat_table[id].mpp = packet['MP%']
                windower.prim.set_size('pmpp'..position_lookup[id],150/100*stat_table[id]['mpp'],5)
                update_macro_data(id,to_update)
                if who_am_i[id] then
                    stat_table[id].name = packet['Name']
                    windower.text.set_text("name"..position_lookup[id],prepare_names(packet['Name']))
                end
                seeking_information:remove(id)
                out_of_zone:remove(id)
        end
    elseif id == 0x0C8 then
        local packet = packets.parse('incoming', data)
        coroutine.yield()
        local packet_id_struc = {
            packet['ID 1'],
            packet['ID 2'],
            packet['ID 3'],
            packet['ID 4'],
            packet['ID 5'],
            packet['ID 6'],
            packet['ID 7'],
            packet['ID 8'],
            packet['ID 9'],
            packet['ID 10'],
            packet['ID 11'],
            packet['ID 12'],
            packet['ID 13'],
            packet['ID 14'],
            packet['ID 15'],
            packet['ID 16'],
            packet['ID 17'],
            packet['ID 18']
        }
        local packet_flag_struc = {
            packet['Flags 1'],
            packet['Flags 2'],
            packet['Flags 3'],
            packet['Flags 4'],
            packet['Flags 5'],
            packet['Flags 6'],
            packet['Flags 7'],
            packet['Flags 8'],
            packet['Flags 9'],
            packet['Flags 10'],
            packet['Flags 11'],
            packet['Flags 12'],
            packet['Flags 13'],
            packet['Flags 14'],
            packet['Flags 15'],
            packet['Flags 16'],
            packet['Flags 17'],
            packet['Flags 18']
        }
        for i = 1,18 do
            if packet_id_struc[i]~=0 then
                if bit_check(packet_flag_struc[i],7) then
                    if bit_check(packet_flag_struc[i],8) then
                        packet_pt_struc[3]:add(packet_id_struc[i])
                    else
                        packet_pt_struc[1]:add(packet_id_struc[i])
                    end
                elseif bit_check(packet_flag_struc[i],8) then
                    packet_pt_struc[2]:add(packet_id_struc[i])
                else
                    packet_pt_struc[1]:add(packet_id_struc[i])
                end
            end
        end
        
        if packet_pt_struc[3]:contains(player_id) then
            packet_pt_struc[1],packet_pt_struc[3] = packet_pt_struc[3],packet_pt_struc[1]
        elseif packet_pt_struc[2]:contains(player_id) then
            packet_pt_struc[1],packet_pt_struc[2] = packet_pt_struc[2],packet_pt_struc[1]
        end
        
        if packet_pt_struc[2]:length() == 0 then
            packet_pt_struc[2],packet_pt_struc[3] = packet_pt_struc[3],packet_pt_struc[2]
        end
        new_members()
    end
end)
