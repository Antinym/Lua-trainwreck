_addon.author = 'Arcon'
_addon.version = '2.1.1.3'
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
defaults.binderPrefix = 'g11_'
defaults.VerboseLevel = 2  -- controls what messages to print. 0 = none, 1 = all but loading binds.lua, 2 = normal info, 3 = debug
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

crumbs_base_string = L{'${name|-}',}:concat('\n')
breadCrumbs = text.new(crumbs_base_string, settings.breadCrumbs, settings)

binds = {}
current = binds
stack = L{binds}
keys = S{}

reset = function()
    current = binds
    while stack:length() >1 do stack:remove() end
    reset_crumbs()
    setgkeys('StackChange')
end

back = function()
    if stack:length() == 1 then
        current = binds
    else
        current = stack[stack:length() - 1]
        stack:remove()
    end
    update_crumbs()
    setgkeys('StackChange')
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
                setgkeys('StackChange')
            end
            return true
        end
        
    end
    
    return false
end

parse_binds = function(fbinds, top)
    top = top or binds

    for key, val in pairs(fbinds) do
        if key:find('%a%d') then
            val = 'alias g11_'..key..' '..val
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
            local crumbs = L{}
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

setgkeys = function(act)
    --windower.send_command('exec clear_all.txt') -- resets all 54 gkeys to ''
    -- damnit the problem is in the clearing of aliases... gotta come up with another method than exec
    -- maybe store the current set in a table and clear them first then set the new ones??
    
    --log('setgkeys called', act) --#test

    for key, val in pairs(current) do
        if key:tostring():find('%a%d') then 
            --[[
            log(key, type(val), val) --#test
            windower.send_command('input /echo sending this command: ' .. val)
            windower.send_command('alias g11_m3g18 input /echo this sucks')
            windower.send_command(val)
            --]]
        end
    end
end

windower.register_event('load', 'login', 'job change', 'logout', function()
    local player = windower.ffxi.get_player()
    local file, path
    local basepath = windower.addon_path .. 'data/'
    
    --if not player then breadCrumbs:hide() end
    if player then
        update_crumbs()
        for filepath in L{
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
    local args = L{...}
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
        
    elseif command == 'set' then
        if args[1] == 'xy' then breadCrumbs:pos(args[2]:number(),args[3]:number())
        elseif args[1] == 'x' then breadCrumbs:pos_x(args[2]:number())
        elseif args[1] == 'y' then breadCrumbs:pos_y(args[2]:number())
        end
        settings:save()
    elseif command == 'p' then
        if args[1] == 'current' then T(current):vprint(true)
        --elseif args[1] ~= nil then T(current).args[1]:vprint(true)
        end
    end
    update_crumbs()
    
end)

--[[
Copyright © 2014, Windower
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Windower nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Windower BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]
