_addon.author = 'Arcon'
_addon.subauthor = 'Kaivalya@Carbuncle'
_addon.version = '2.5.2.2'
_addon.language = 'English'
_addon.command = 'yuk'

do 
    require('logger')
    require('strings')
    require('tables')
    require('lists') -- Modified version: lists.merge added
    require('sets')
    require('maths')
    require('functions')

    collectgarbage()
end
libs = {}
libs.config = require ('config')
libs.text = require('texts')

function yuk_set_env(action)
    if action == 'job change' and _innerG then  
        --_innerG._binds = nil
        --_innerG._binds = {} 
        logout()
    elseif _innerG then 
        return 
    end
    
    _innerG = {_binds={}}
    for k, v in pairs(_G) do
        if k ~= 'global' then
            rawset(_innerG, k, v)
        end
    end
    _innerG._innerG = nil
    _innerG._G = _innerG

    _innerG.include = function(path)
        local full_path = windower.addon_path .. 'data/' .. path

        local file = loadfile(full_path)
        if not file and global.defaults.VerboseLevel > 0 then
            warning('Include file %s not found.':format(path))
            return
        end

        setfenv(file, _innerG)
        file()
    end

    setmetatable(_innerG, {__index = function(g, k)
        local t = rawget(rawget(g, '_binds'), k)
        if not t then
            t = {}
            rawset(rawget(g, '_binds'), k, t)
        end
        return t
    end, __newindex = function(g, k, v)
        local t = rawget(rawget(g, '_binds'), k)
        if t and type(v) == 'table' then
            for k, v in pairs(v) do
                t[k] = v
            end
        else
            rawset(rawget(g, '_binds'), k, v)
        end
    end})
end 

-- Load Defaults
function load_defaults()
    -- Do not load anything if we are not logged in
    if (not windower.ffxi.get_info().logged_in) then return end

    -- Skip if defaults have been loaded already
    if (global) then return end

    global = {}
    global.defaults = {}
    global.defaults.ResetKey = '`'
    global.defaults.BackKey = 'backspace'
    global.defaults.binder = {}
    global.defaults.binder.prefix = 'g11_'
    global.defaults.binder.activeset = T{'m1g1','m1g2','m1g3','m1g4','m1g5','m1g6','m1g7','m1g8','m1g9','m1g10','m1g11','m1g12','m1g13','m1g14','m1g15','m1g16','m1g17','m1g18',
            'm2g1','m2g2','m2g3','m2g4','m2g5','m2g6','m2g7','m2g8','m2g9','m2g10','m2g11','m2g12','m2g13','m2g14','m2g15','m2g16','m2g17','m2g18',
            'm3g1','m3g2','m3g3','m3g4','m3g5','m3g6','m3g7','m3g8','m3g9','m3g10','m3g11','m3g12','m3g13','m3g14','m3g15','m3g16','m3g17','m3g18'}
    global.defaults.VerboseLevel = 2  -- controls what messages to print. 0 = none, 1 = mostly just error messages, 2 = normal info, 3 = debug
    global.defaults.showCrumbs = true
    global.defaults.breadCrumbs = {}
    global.defaults.breadCrumbs.pos = {}
    global.defaults.breadCrumbs.pos.x = (windower.get_windower_settings().ui_x_res / 2) - 50
    global.defaults.breadCrumbs.pos.y = 0
    global.defaults.breadCrumbs.text = {}
    global.defaults.breadCrumbs.text.font = 'arial'
    global.defaults.breadCrumbs.text.size = 10
    global.defaults.breadCrumbs.text.alpha = 255
    global.defaults.breadCrumbs.text.red = 255
    global.defaults.breadCrumbs.text.green = 255
    global.defaults.breadCrumbs.text.blue = 255
    global.defaults.breadCrumbs.bg = {}
    global.defaults.breadCrumbs.bg.alpha = 192
    global.defaults.breadCrumbs.bg.red = 0
    global.defaults.breadCrumbs.bg.green = 0
    global.defaults.breadCrumbs.bg.blue = 0
    global.defaults.breadCrumbs.padding = 5
    global.defaults.breadCrumbs.name = nil
    global.crumbs_base_string = T{'${name|-}',}:concat('\n')
    
    global.player_name = windower.ffxi.get_player().name
    global.settings_file = "data/settings/%s.xml":format(global.player_name)
    
    -- Load previous settings
    global.settings = libs.config.load(global.settings_file, global.defaults)
    
    global.breadCrumbs = libs.text.new (global.crumbs_base_string, global.settings.breadCrumbs)
 
--    global.enable_mode = true
    global.yuk = {}
    global.yuk.binds = T{}
    global.yuk.current = binds
    global.yuk.stack = T{global.yuk.binds}
    global.yuk.keys = S{}
    global.binder = {}
    global.binder.bmenus = {}  --#binder table of [menu names] = table reference
    global.binder.bstack = T{} --#binder binder stack from current
    global.binder.alocks = T{} --#binder locks aliases in current
    global.binder.plocks = T{} --#binder player specified locks 
    global.binder.lock_actions = L{'la','ld','ll','las','lds',}
    -- iterator
    global.itest = 1
    
    update_area_info()
    yuk_set_env()
    yuk_initialize()
end

-- update area location
function update_area_info()
    -- Load defaults if needed
    if (not global) then load_defaults() return end
    --update_settings() might use later
end

function yuk_initialize()
    -- Do not load anything if we are not logged in
    if (not windower.ffxi.get_info().logged_in) then return end
    
    local player = windower.ffxi.get_player()
    local file, path
    local basepath = windower.addon_path .. 'data/'
    
    if player then
        for filepath in T{
            {path = 'name_main_sub.lua',    format = '%s\'s %s/%s'},
            {path = 'name_main.lua',        format = '%s\'s %s'},
            {path = 'name.lua',             format = '%s\'s'},
        }:it() do
            path = filepath.format:format(player.name, player.main_job, player.sub_job or '')
            file = loadfile(basepath .. filepath.path:gsub('name', player.name):gsub('main', player.main_job):gsub('sub', player.sub_job or ''))
            if file then
                break
            end
        end
    end

    if not file then
        path = 'Binds'
        file = loadfile(basepath .. 'binds.lua')
    end
    
    if file then
        rawset(_innerG, '_binds', {})
        setfenv(file, _innerG)
        parse_binds(file())
        reset()
        if path == 'Binds' and global.settings.VerboseLevel  < 2 then
            -- don't print('yuk: Loaded ' .. path .. ' Lua file')
        else
            print('yuk: Loaded ' .. path .. ' Lua file')
        end
    elseif player then
        global.breadCrumbs:hide()
        if global.settings.VerboseLevel > 0 then
            print('yuk: No matching file found for %s (%s%s)':format(player.name, player.main_job, player.sub_job and '/' .. player.sub_job or ''))
        end
    end
end

function logout()
    rawset(_innerG, '_binds', nil)
    rawset(_G, '_innerG', nil)
    if (global.breadCrumbs) then
        global.breadCrumbs:hide()
        global.breadCrumbs:destroy()
    end
    rawset(_G, 'global', nil)
    collectgarbage()
end

-- Save settings
function save_settings()
    update_settings()
    libs.config.save(global.settings, 'all')
end

function test_loop ()
    print(itest)
    itest = itest +1
end

--#yuk
reset = function()
    global.yuk.current = global.yuk.binds
    while global.yuk.stack:length() >1 do global.yuk.stack:remove() end
    reset_crumbs()
    binder_process('StackChange')
end

back = function()
    if global.yuk.stack:length() == 1 then
        global.yuk.current = global.yuk.binds
    else
        global.yuk.current = global.yuk.stack[global.yuk.stack:length() - 1]
        global.yuk.stack:remove()
    end
    update_crumbs()
    binder_process('StackChange')
end

check = function()
    for key, val in pairs(global.yuk.current) do
        if key <= global.yuk.keys then
            if type(val) == 'string' then
                if val == 'printset' then
                    table.vprint(global.yuk.stack[global.yuk.stack:length()])
                else
                    windower.send_command(val)
                end
            else
                global.yuk.current = val
                global.yuk.stack:append(global.yuk.current)
                binder_process('StackChange')
            end
            return true
        end
        
    end
    
    return false
end

parse_binds = function(fbinds, top)
    top = top or global.yuk.binds
    
    for key, val in pairs(fbinds) do
        if string.find(key,'%a%d') and type(val) == 'table' then
            if val['menu'] then
                key = key .. '+' .. val['menu']
            else
                warning('You need to add a menu name to the ' .. key .. ' macro table.')
            end
        end
            
        key = S(key:split('+')):map(string.lower)
            
        if type(val) == 'string' then
                rawset(top, key, val)
        else
                rawset(top, key, {})
                parse_binds(val, rawget(top, key))
        end
    end
end

reset_crumbs = function()
    if not global.breadCrumbs then
        global.breadCrumbs = libs.text.new (global.crumbs_base_string, global.settings.breadCrumbs)
    end
    
    for key, val in pairs(global.yuk.current) do
        if key:find('name') then 
            global.breadCrumbs.name = val
            return 
        end
    end
end

update_crumbs = function(...)
    if global.settings.showCrumbs == true then
        if ... then 
            global.breadCrumbs.name = ...
        else
            local crumbs = T{}
            local stack_level
            if global.yuk.stack:length() == 1 then 
                reset_crumbs()
            else
                stack_level = global.yuk.stack:length()
                for k = 1, stack_level do 
                    for key, val in pairs(global.yuk.stack[k]) do
                        if key:find('name') then 
                            crumbs:append(val)
                        end
                    end
                end
                global.breadCrumbs.name = crumbs:concat(' : ')
             end
            
        end
        global.breadCrumbs:show()
    else
        global.breadCrumbs:hide()
    end
end

toggle_crumbs = function(b)
    if b ~= nil then
        global.settings.showCrumbs = b
    else
        global.settings.showCrumbs = not global.settings.showCrumbs
    end
    
    return global.settings.showCrumbs
end

binder_process = function(act)--#binder
    if act == 'StackChange' then 
        global.binder.alocks:clear()
    end
    
    for key, val in pairs(global.yuk.current) do
        local bkey 
        bkey = key:tostring():slice(2,-2)
        if bkey:find('%a%d') then 
            binder_preset(bkey)
            binder_set(bkey, val)
        end
    end
    binder_postset()
end

binder_stack = function(act,bkey)--#binder
    if act == 'append' then global.binder.bstack:append(bkey) end
    if act == 'delete' then 
        windower.send_command('alias ' .. global.settings.binder.prefix .. bkey .. '')
        global.binder.bstack:delete(bkey) 
    end
end

binder_preset = function(key)--#binder
    -- checks for a lock on that alias and if no lock, removes from bstack, then sets unlocked to blank and returns true
    if global.binder.bstack:contains(key) and global.binder.plocks:contains(key) then
        if global.settings.VerboseLevel  < 2 then
            log('Lock detected: ' .. key .. ' not unsetset because it is locked.')
        end
        return false
    elseif global.binder.bstack:contains(key) and not global.binder.plocks:contains(key) then
        binder_stack('delete')
    end
    
    return true
end

binder_set = function(k, a)
    local ret
    
    if global.binder.plocks:contains(k) then ret = false
    elseif type(a) == 'table' then
        local menu_set, key, menu = {}
        menu_set = string.split(k,', ')
        key = menu_set[1]:find('%a%d') and menu_set[1] or menu_set[2]
        menu = not menu_set[1]:find('%a%d') and menu_set[1] or menu_set[2]
        global.binder.alocks:append(key)
        
        windower.send_command('alias ' .. global.settings.binder.prefix .. key .. ' yuk press ' .. key .. '+' .. menu)
        ret = true
    elseif a:startswith('lock ') then 
        a = a:slice(6)
        windower.send_command('alias ' .. global.settings.binder.prefix .. k .. ' ' .. a)
        global.binder.alocks:append(k)
        global.binder.plocks:append(k)
        
        ret = true
    else windower.send_command('alias ' .. global.settings.binder.prefix .. k .. ' ' .. a)
        global.binder.alocks:append(k)
        ret = true
    end
    return ret
end


binder_postset = function()
    return binder_clearset()
end

-- I can't remember why I added the locks arg. Do you know why?
binder_clearset = function(locks, aset)--#binder
    local aset = aset or global.settings.binder.activeset
    local locks = locks or T{}:extend(global.binder.alocks):extend(global.binder.plocks)
    aset:map(function(a) 
        if not locks:contains(a) then
            return windower.send_command('alias ' .. global.settings.binder.prefix .. a .. ' ;') 
        end 
    end)
end

binder_locks = function(action, ...)
    local locklist = T{...}
    local res = ''
    local silent = false
    local act = action or 'la'
    
    if act:endswith('s') then silent = true end
    if act:match('l[adl]') then act = act:sub(1,3) end
    
    if not string.match(act,'l[adl]') then 
        act = 'la'
        global.binder.locklist:append(action) end
    
    if act == 'll' then res = res .. 'Alias Locks: ' .. global.binder.plocks:concat(', ')
    elseif act == 'la' then global.binder.plocks:merge(locklist)
        res = res .. 'Locking successful.'
    elseif act == 'ld' then 
        for _, v in pairs(locklist) do
            repeat until not global.binder.plocks:delete(v)
        end
        res = res .. 'Unlocking successful.'
    end
    if global.settings.VerboseLevel < 2 and act ~= 'll' then 
        res = false 
    else
        res = not silent and res
    end
    return res
end

dikt = {    -- Har har
    [1] = 'esc',
    [2] = '1',
    [3] = '2',
    [4] = '3',
    [5] = '4',
    [6] = '5',
    [7] = '6',
    [8] = '7',
    [9] = '8',
    [10] = '9',
    [11] = '0',
    [12] = '-',
    [13] = '=',
    [14] = 'backspace',
    [15] = 'tab',
    [16] = 'q',
    [17] = 'w',
    [18] = 'e',
    [19] = 'r',
    [20] = 't',
    [21] = 'y',
    [22] = 'u',
    [23] = 'i',
    [24] = 'o',
    [25] = 'p',
    [26] = '[',
    [27] = ']',
    [28] = 'enter',
    [29] = 'ctrl',
    [30] = 'a',
    [31] = 's',
    [32] = 'd',
    [33] = 'f',
    [34] = 'g',
    [35] = 'h',
    [36] = 'j',
    [37] = 'k',
    [38] = 'l',
    [39] = ';',
    [40] = '\'',
    [41] = '`',
    [42] = 'shift',
    [43] = '\\',
    [44] = 'z',
    [45] = 'x',
    [46] = 'c',
    [47] = 'v',
    [48] = 'b',
    [49] = 'n',
    [50] = 'm',
    [51] = ',',
    [52] = '.',
    [53] = '/',
    [54] = nil,
    [55] = 'num*',
    [56] = 'alt',
    [57] = 'space',
    [58] = nil,
    [59] = 'f1',
    [60] = 'f2',
    [61] = 'f3',
    [62] = 'f4',
    [63] = 'f5',
    [64] = 'f6',
    [65] = 'f7',
    [66] = 'f8',
    [67] = 'f9',
    [68] = 'f10',
    [69] = 'num',
    [70] = 'scroll',
    [71] = 'num7',
    [72] = 'num8',
    [73] = 'num9',
    [74] = 'num-',
    [75] = 'num4',
    [76] = 'num5',
    [77] = 'num6',
    [78] = 'num+',
    [79] = 'num1',
    [80] = 'num2',
    [81] = 'num3',
    [82] = 'num0',

    [199] = 'home',
    [200] = 'up',
    [201] = 'pageup',
    [202] = nil,
    [203] = 'left',
    [204] = nil,
    [205] = 'right',
    [206] = nil,
    [207] = 'end',
    [208] = 'down',
    [209] = 'pagedown',
    [210] = 'insert',
    [211] = 'delete',
    [219] = 'win',
    [220] = 'rwin',
    [221] = 'apps',
}
function yuk_event_keyboard (dik, down)
    -- Do not load anything if we are not logged in
    if (not windower.ffxi.get_info().logged_in) then return end

    local key = dikt[dik]
    
    if global.settings.VerboseLevel >= 3 then notice('pressed keys =', keys) end
    if not key then
        return
    end

    if not down then
        global.yuk.keys:remove(key)
        return
    end

    if not global.yuk.keys:contains(key) then
        global.yuk.keys:add(key)

        if not windower.ffxi.get_info().chat_open then
            if key == global.settings.ResetKey then
                reset()
                return true
            elseif key == global.settings.BackKey then
                back()
                return true
            end
        end

        return check(), update_crumbs()
    end
end

function yuk_commands (command, ...)
    command = command and command:lower() or 'help'
    local args = T{...}
    if command == 'reset' then
        --log('reset')
        reset()

    elseif command == 'back' then
        --log('back')
        back()

    elseif command == 'press' then
        global.yuk.keys = global.yuk.keys + S(args[1]:split('+')):map(string.lower)
        check()
        global.yuk.keys = global.yuk.keys - S(args[1]:split('+')):map(string.lower)
        
    elseif command == 'r' then
        windower.send_command('lua r yuk')
    
    elseif command == 'u' then
        windower.send_command('lua u yuk')
    
    elseif command == 'h' then --hide crumbs
        toggle_crumbs(false)
    
    elseif command == 's' then --show crumbs
        toggle_crumbs(true)
        
    elseif global.binder.lock_actions:contains(command) then --locks
        local mes = binder_locks(command, args:unpack())
        if mes then log(mes) end
    
    elseif command == 'lav2' then
        global.binder.alocks:append(args[1])
        global.binder.plocks:append(args[1])
        
    elseif command == 'ldv2' then   
        global.binder.plocks:delete(args[1])
        
    elseif command == 'set' then
        if args[1] == 'xy' then global.breadCrumbs:pos(args[2]:number(),args[3]:number())
        elseif args[1] == 'x' then global.breadCrumbs:pos_x(args[2]:number())
        elseif args[1] == 'y' then global.breadCrumbs:pos_y(args[2]:number())
        end
        global.settings:save()
    elseif command == 'p' then
        local outf, output, t, g, j
        outf = T{['print'] = print, ['log'] = log, ['warning'] = warning, ['error'] = error, ['notice'] = notice,}
        output = outf:containskey(args[#args]) and outf[args[#args]] or log
        local t = rawget(_G,args[1])
        local g = t and rawget(t, args[2]) or t
        local j = g and rawget(g, args[3]) or g
        for k, v in pairs(j) do
            output('> ', k, ' > - < ', v)
        end
    elseif command == 'pstack' then 
        global.yuk.stack:vprint(true)
        log(type(global.yuk.stack))
    end
    update_crumbs()
end

windower.register_event('load', 'login', load_defaults)
windower.register_event('job change', function()
    logout()
    load_defaults()
end)
windower.register_event('logout', 'unload', logout)
windower.register_event('keyboard', yuk_event_keyboard)
windower.register_event('addon command', yuk_commands)
--[=[ Task List
[ ]) Add support for multiple binder devices ;;... make a function that handles identifying the type of macro
    ->) This is actually a spot where a metatable would work probably
    ->) Check if sets support 3+ elements; can add the device identifier to the set
[ ]) move all binder functions into an include and add sugar
[ ]) replace current alias identifiers with placeholder ident parts. ie... instead of (m1)(g)1 use (p)1(k)1 and a customizable
        filter to replace based on settings.  This will allow for non-set specific includes.
[ ]) figure out a better method for handling activesets (for alias clearing) -- can do a few things
        option 1) define a mask for each binder device, eg. g11 = { prefix = 'g11_', page = 'm', page_range = {1,3}, key = 'g', key_range = {1,18} }
                    
[ ]) Add an ignorelock arguement to binder_locks() so aliases can be cleared on logout/unload
[ ]) Add locking of macros
[ ]) Add textbox for locks
[ ]) Add textbox for macros/aliases
[ ]) possibly rewrite for metatables and environments
    ->) partial rewrite completed... don't know if it helped
[ ]) add macros/aliases from console to specific binds tables
-- [ ]) export current binds or new binds
-- --) create include files and if exist append
[x]) clean up duplicate entries in locks

>> Notes
*> I apologize if this poor coder has offended, 
*> Think but this, and all is mended,
*> That you have not executed here,
*> What could have made your game disappear,
*> This weak and idle theme,
*> No more yielding but a dream,
*> Gentles, no not reprehend:
*> if you pardon, I will mend:
*> And, as I am an honest Kai,
*> If luck, unearned by this guy
*> Now to 'scape the serpent's tongue,
*> I shall make amends ere long;
*> Else the Kai a liar call,
*> So, good night, until you all.
--]=]

--[[
Copyright © 2014, Windower
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Windower nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Windower BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]
