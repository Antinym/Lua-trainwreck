_addon.author = 'Arcon'
_addon.version = '2.2.0.0'
_addon.language = 'English'
_addon.command = 'yush'

require('luau')
text = require('texts')

_innerG = {_binds={}}
for k, v in pairs(_G) do
    rawset(_innerG, k, v)
end
_innerG._innerG = nil
_innerG._G = _innerG

_innerG.include = function(path)
    local full_path = windower.addon_path .. 'data/' .. path

    local file = loadfile(full_path)
    if not file and settings.VerboseLevel > 0 then
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

defaults = {}
defaults.ResetKey = '`'
defaults.BackKey = 'backspace'
defaults.binder = {}
defaults.binder.prefix = 'g11_'
defaults.binder.activeset = T{'m1g1','m1g2','m1g3','m1g4','m1g5','m1g6','m1g7','m1g8','m1g9','m1g10','m1g11','m1g12','m1g13','m1g14','m1g15','m1g16','m1g17','m1g18',
		'm2g1','m2g2','m2g3','m2g4','m2g5','m2g6','m2g7','m2g8','m2g9','m2g10','m2g11','m2g12','m2g13','m2g14','m2g15','m2g16','m2g17','m2g18',
		'm3g1','m3g2','m3g3','m3g4','m3g5','m3g6','m3g7','m3g8','m3g9','m3g10','m3g11','m3g12','m3g13','m3g14','m3g15','m3g16','m3g17','m3g18'}
defaults.VerboseLevel = 2  -- controls what messages to print. 0 = none, 1 = mostly just error messages, 2 = normal info, 3 = debug
defaults.showCrumbs = true
defaults.breadCrumbs = {}
defaults.breadCrumbs.pos = {}
defaults.breadCrumbs.pos.x = 0
defaults.breadCrumbs.pos.y = 0
defaults.breadCrumbs.text = {}
defaults.breadCrumbs.text.font = 'arial'
defaults.breadCrumbs.text.size = 10
defaults.breadCrumbs.text.alpha = 255
defaults.breadCrumbs.text.red = 255
defaults.breadCrumbs.text.green = 255
defaults.breadCrumbs.text.blue = 255
defaults.breadCrumbs.bg = {}
defaults.breadCrumbs.bg.alpha = 192
defaults.breadCrumbs.bg.red = 0
defaults.breadCrumbs.bg.green = 0
defaults.breadCrumbs.bg.blue = 0
defaults.breadCrumbs.padding = 5
defaults.breadCrumbs.name = nil

settings = config.load(defaults)

crumbs_base_string = T{'${name|-}',}:concat('\n')
breadCrumbs = text.new(crumbs_base_string, settings.breadCrumbs, settings)

binds = {}
current = binds
stack = T{binds}
keys = S{}
bstack = T{} --#binder binder stack from current
alocks = T{} --#binder locks aliases in current
plocks = T{'m3g17',} --#binder player specified locks 
lock_actions = L{'a','d','l',}
itest = 1

reset = function()
    current = binds
    while stack:length() >1 do stack:remove() end
    reset_crumbs()
    binder_process('StackChange')
end

back = function()
    if stack:length() == 1 then
        current = binds
    else
        current = stack[stack:length() - 1]
        stack:remove()
    end
    update_crumbs()
    binder_process('StackChange')
end

check = function()
    for key, val in pairs(current) do
        if key <= keys then
            if type(val) == 'string' then
                if val == 'printset' then
                    table.vprint(T(stack[stack:length()]))
                else
                    windower.send_command(val)
                end
            else
                current = val
                stack:append(current)
                binder_process('StackChange')
            end
            return true
        end
        
    end
    
    return false
end

parse_binds = function(fbinds, top)
  if not T(top):empty() then T(top):vprint(true) end
    top = top or binds
    local ll, ls, la = {}
    
    for key, val in pairs(fbinds) do
        if key == 'lock' then 
            if type(val) == 'string' then al, ls = string.sub(val,1 ,2), string.sub(val,3)
            else al = 'a'
                for it, va in ipairs(val) do ll[it] = va end
            end
        else
            key = S(key:split('+')):map(string.lower)
            if type(val) == 'string' then
                rawset(top, key, val)
            else
                rawset(top, key, {})
                parse_binds(val, rawget(top, key))
            end
        end
    end
    if ls and type(ls) == 'string' then binder_locks(al, ls) else binder_locks(al, unpack(ll)) end 
end

reset_crumbs = function()
    for key, val in pairs(current) do
        if key:find('name') then 
            breadCrumbs.name = val
            return 
        end
    end
end

update_crumbs = function(...)
    if breadCrumbs == nil then -- check if breadCrumbs was destroyed on logout
        breadCrumbs = text.new(crumbs_base_string, settings.breadCrumbs, settings)
    end
    if settings.showCrumbs == true then
        if ... then 
            breadCrumbs.name = ...
        else
            local crumbs = T{}
            local stack_level
            if stack:length() == 1 then 
                reset_crumbs()
            else
                stack_level = stack:length()
                for k = 1, stack_level do 
                    for key, val in pairs(stack[k]) do
                        if key:find('name') then 
                            crumbs:append(val)
                        end
                    end
                end
                breadCrumbs.name = crumbs:concat(' : ')
             end
            
        end
        breadCrumbs:show()
    else
        breadCrumbs:hide()
    end
end

toggle_crumbs = function(b)
    if b ~= nil then
        settings.showCrumbs = b
    else
        settings.showCrumbs = not settings.showCrumbs
    end
    
    return settings.showCrumbs
end

binder_process = function(act)--#binder
    if act == 'StackChange' then 
        alocks:clear()
    end
    
    for key, val in pairs(current) do
        key = key:tostring():slice(2,-2)
        if key:find('%a%d') then 
            binder_preset(key)
            binder_set(key, val)
        end
    end
    binder_postset()
end

binder_stack = function(act,bkey)--#binder
    if act == 'append' then bstack:append(bkey) end
    if act == 'delete' then 
        windower.send_command('alias ' .. settings.binder.prefix .. bkey .. '')
        bstack:delete(bkey) 
    end
end

binder_preset = function(key)--#binder
    -- checks for a lock on that alias and if no lock, removes from bstack, then sets unlocked to blank and returns true
    if bstack:contains(key) and plocks:contains(key) then
        if settings.VerboseLevel  < 2 then
            log('Lock detected: ' .. key .. ' not unsetset because it is locked.')
        end
        return false
    elseif bstack:contains(key) and not plocks:contains(key) then
        binder_stack('delete')
    end
    
    return true
end

binder_set = function(k, a)
    local ret
    alocks:append(k)
    if plocks:contains(k) then ret = false
    else windower.send_command('alias ' .. settings.binder.prefix .. k .. ' ' .. a)
        ret = true
    end
    return ret
end


binder_postset = function()
    return binder_clearset()
end

-- I can't remember why I added the locks arg. Do you know why?
binder_clearset = function(locks, aset)--#binder
    local aset = aset or settings.binder.activeset
    local locks = locks or T{}:extend(alocks):extend(plocks)
    aset:map(function(a) 
        if not locks:contains(a) then
            return windower.send_command('alias ' .. settings.binder.prefix .. a .. ' ;') 
        end 
    end)
end

binder_locks = function(action, ...)
    local locklist = T{...}
    local res, act = '', string.match(action,'[adl]') and action or 'a'
    
    if not string.match(action,'[adl]') then locklist:append(action) end
    
    if act == 'l' then res = res .. 'Alias Locks: ' .. plocks:concat(', ')
    elseif act == 'a' then plocks:extend(locklist)
        res = res .. 'Locking successful.'
    elseif act == 'd' then 
        for _, v in pairs(locklist) do
            repeat until not plocks:delete(v)
        end
        res = res .. 'Unlocking successful.'
    end
    if settings.VerboseLevel < 2 and act ~= 'l' then res = false end
    return res
end

windower.register_event('load', 'login', 'job change', 'logout', function()
    local player = windower.ffxi.get_player()
    local file, path
    local basepath = windower.addon_path .. 'data/'
    
    --if not player then breadCrumbs:hide() end
    if player then
        update_crumbs()
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
        setfenv(file, _innerG)
        parse_binds(file())
        reset()
        if path == 'Binds' and settings.VerboseLevel  < 2 then
            -- don't print('Yush: Loaded ' .. path .. ' Lua file')
        else
            print('Yush: Loaded ' .. path .. ' Lua file')
        end
    elseif player then
        breadCrumbs:hide()
        if settings.VerboseLevel > 0 then
            print('Yush: No matching file found for %s (%s%s)':format(player.name, player.main_job, player.sub_job and '/' .. player.sub_job or ''))
        end
    end
end)

windower.register_event('login', function()
    --breadCrumbs:destroy()
    --breadCrumbs.name = ''
    --breadCrumbs = nil
    
    --**on login it uses the last character's top(stack?)
    windower.send_command('lua r yush')
end)

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

windower.register_event('keyboard', function(dik, down)
    local key = dikt[dik]
    
    if settings.VerboseLevel >= 3 then notice('pressed keys =', keys) end
    if not key then
        return
    end

    if not down then
        keys:remove(key)
        return
    end

    if not keys:contains(key) then
        keys:add(key)

        if not windower.ffxi.get_info().chat_open then
            if key == settings.ResetKey then
                reset()
                return true
            elseif key == settings.BackKey then
                back()
                return true
            end
        end

        return check(), update_crumbs()
    end
end)

windower.register_event('addon command', function(command, ...)
    command = command and command:lower() or 'help'
    local args = T{...}
    if command == 'reset' then
        reset()

    elseif command == 'back' then
        back()

    elseif command == 'press' then
        keys = keys + S(args[1]:split('+')):map(string.lower)
        check()
        keys = keys - S(args[1]:split('+')):map(string.lower)
        
    elseif command == 'r' then
        windower.send_command('lua r yush')
    
    elseif command == 'u' then
        windower.send_command('lua u yush')
    
    elseif command == 'h' then
        toggle_crumbs(false)
    
    elseif command == 's' then
        toggle_crumbs(true)
        
    elseif command == 'l' then
        local mes = binder_locks(args:unpack())
        if mes then log(mes) end
        
    elseif command == 'set' then
        if args[1] == 'xy' then breadCrumbs:pos(args[2]:number(),args[3]:number())
        elseif args[1] == 'x' then breadCrumbs:pos_x(args[2]:number())
        elseif args[1] == 'y' then breadCrumbs:pos_y(args[2]:number())
        end
        settings:save()
    elseif command == 'p' then
        if args[1] == 'current' then T(current):vprint(true)
        elseif args[1] == 'plocks' then T(plocks):vprint(true)
        --elseif args[1] ~= nil then T(current).args[1]:vprint(true)
        end
    end
    update_crumbs()
    
end)
--[=[ Task List
*) Add locking from loaded files
--) in parse_binds trap for ['lock'] key
----) if type == string then binder_locks(val)
----) elseif type == table 
*) Add locking of macros
*) Add textbox for locks
*) Add textbox for macros/aliases
*) possibly rewrite for metatables and environments
*) add macros/aliases from console to specific binds tables
-- *) export current binds or new binds
-- --) create include files and if exist append
*) clean up duplicate entries in locks
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
