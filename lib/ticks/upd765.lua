-- A model of the uPD765A floppy controller in non-DMA mode, for z88dk-ticks (and anything else that can call it from a port handler): the command, execution and result phases, the
-- main status register, seek and recalibrate ending with an interrupt status that Sense Interrupt Status reads, the terminal count ending a transfer, and one disc.  It checks as it
-- goes (the commands are MFM, 256 byte sectors, the motor is on, the terminal count comes) and collects what it did not like in .errors.
--
--   local fdc = require("upd765")({ image = "x.d88", cylinders = 40, heads = 2, sectors = 16, trace = false })
--   fdc.msr()           the main status register          fdc.data_read() / fdc.data_write(v)   the data register
--   fdc.tc()            the terminal count                fdc.motor(true)                        the drive's motor
--   fdc.dump(dir)       writes dir/disk_out.txt (the sectors written: "cyl head id hex") and dir/fdc_log.txt (commands and errors)
-- The sector contents are those of the .d88 (an image of cylinder*heads tracks of `sectors` sectors, 256 bytes each), or a pattern of cylinder, head, id and position if there is none.
return function(opts)
opts = opts or {}
local TRACKS, HEADS, SPT = opts.cylinders or 40, opts.heads or 2, opts.sectors or 16
local motor = false
local spin = 0
local pcn = { 0, 0, 0, 0 }
local seeking = { 0, 0, 0, 0 }
local int_pending = nil
local state, cmd, need = "cmd", {}, 0
local results, ridx = {}, 0
local xfer, xpos, awaiting_tc, xinfo = nil, 0, false, nil
local nd_mode = false
local written = {}
local log = {}
local errors = {}

-- opts.image: a .d88 disc image to serve instead of the pattern
local image = {}
do
    local path = opts.image
    if path then
        local f = assert(io.open(path, "rb"))
        local d = f:read("a")
        f:close()
        for t = 0, TRACKS * HEADS - 1 do
            local off = string.unpack("<I4", d, 0x20 + 4 * t + 1) + 1
            for _ = 1, SPT do
                local c, h, r, n = string.unpack("BBBB", d, off)
                local size = string.unpack("<I2", d, off + 14)
                image[c * 10000 + h * 100 + r] = d:sub(off + 16, off + 15 + size)
                off = off + 16 + size
            end
        end
    end
end
local has_image = opts.image ~= nil

local function pattern(c, h, id, i) return (c * 7 + h * 13 + id * 29 + i) & 0xff end
local function key(c, h, id) return c * 10000 + h * 100 + id end
local function sector_byte(c, h, id, i)
    local w = written[key(c, h, id)]
    if w then return w[i + 1] end
    if has_image then return image[key(c, h, id)]:byte(i + 1) end
    return pattern(c, h, id, i)
end

local function selected()
    return (cpusel & 1) == (PACK_SLOT >> 2) and (iosel & 3) == (PACK_SLOT & 3)
end

local function to_result(list)
    results, ridx, state = list, 1, "result"
end

local function msr()
    local busy = 0
    for u = 0, 3 do
        if seeking[u + 1] > 0 then
            seeking[u + 1] = seeking[u + 1] - 1
            busy = busy | (1 << u)
            if seeking[u + 1] == 0 then busy = busy & ~(1 << u) end
        end
    end
    if state == "cmd" then
        return 0x80 | (#cmd > 0 and 0x10 or 0) | busy
    elseif state == "read" then return 0xF0
    elseif state == "write" then return 0xB0
    elseif state == "tc" then
        -- no terminal count came: the controller goes on, past the end of the track: abnormal termination, end of cylinder
        local i = xinfo
        to_result({ 0x40 | (i.hd << 2) | i.unit, 0x80, 0, i.c, i.h, i.r, i.n })
        errors[#errors + 1] = "no terminal count"
        return 0xD0
    else return 0xD0 end
end

local function finish_cmd()
    local c = cmd[1] & 0x1f
    log[#log + 1] = string.format("cmd %s", table.concat((function() local t = {} for i, v in ipairs(cmd) do t[i] = string.format("%02x", v) end return t end)(), " "))
    if c == 0x03 then
        nd_mode = (cmd[3] & 1) == 1
        state = "cmd"
    elseif c == 0x04 then
        local u = cmd[2] & 3
        if motor then spin = spin + 1 end
        local st3 = u | (cmd[2] & 4) | 0x08 | ((pcn[u + 1] == 0) and 0x10 or 0) | ((motor and spin >= 3) and 0x20 or 0)
        to_result({ st3 })
    elseif c == 0x07 then
        local u = cmd[2] & 3
        pcn[u + 1] = 0
        seeking[u + 1] = 3
        int_pending = { 0x20 | u, 0 }
        state = "cmd"
    elseif c == 0x0f then
        local u = cmd[2] & 3
        if cmd[3] >= TRACKS then
            seeking[u + 1] = 3
            int_pending = { 0x60 | u, pcn[u + 1] }       -- seek end with equipment check: there is no such cylinder
        else
            pcn[u + 1] = cmd[3]
            seeking[u + 1] = 3
            int_pending = { 0x20 | u, cmd[3] }
        end
        state = "cmd"
    elseif c == 0x08 then
        if int_pending then to_result({ int_pending[1], int_pending[2] }); int_pending = nil
        else to_result({ 0x80 }) end
    elseif c == 0x06 or c == 0x05 then
        local u, hd = cmd[2] & 3, (cmd[2] >> 2) & 1
        local info = { unit = u, hd = hd, c = cmd[3], h = cmd[4], r = cmd[5], n = cmd[6], eot = cmd[7] }
        xinfo = info
        info.write = (c == 0x05)
        if not nd_mode then errors[#errors + 1] = "data command in DMA mode" end
        if cmd[1] & 0x40 == 0 then errors[#errors + 1] = "not MFM" end
        if not motor then errors[#errors + 1] = "motor off" end
        if info.n ~= 1 then errors[#errors + 1] = "N is not 1" end
        if info.c ~= pcn[u + 1] or info.h ~= hd or info.r < 1 or info.r > SPT then
            to_result({ 0x40 | (hd << 2) | u, 0x04, 0, info.c, info.h, info.r, info.n })   -- no data
            return
        end
        xpos = 0
        if c == 0x06 then
            xfer = {}
            for i = 0, 255 do xfer[i + 1] = sector_byte(info.c, info.h, info.r, i) end
            state = "read"
        else
            xfer = {}
            state = "write"
        end
    else
        errors[#errors + 1] = string.format("unknown command %02x", cmd[1])
        to_result({ 0x80 })
    end
    cmd = {}
end

local lens = { [0x03] = 3, [0x04] = 2, [0x05] = 9, [0x06] = 9, [0x07] = 2, [0x08] = 1, [0x0f] = 3 }

local function data_write(v)
    if state == "cmd" then
        cmd[#cmd + 1] = v
        local n = lens[cmd[1] & 0x1f]
        if not n then n = 1 end
        if #cmd >= n then finish_cmd() end
    elseif state == "write" then
        xfer[#xfer + 1] = v
        if #xfer == 256 then state, awaiting_tc = "tc", true end
    else
        errors[#errors + 1] = "data written in state " .. state
    end
end

local function data_read()
    if state == "read" then
        local v = xfer[xpos + 1]
        xpos = xpos + 1
        if xpos == 256 then state = "tc" end
        return v
    elseif state == "result" then
        local v = results[ridx]
        ridx = ridx + 1
        if ridx > #results then state, cmd = "cmd", {} end
        return v
    end
    errors[#errors + 1] = "data read in state " .. state
    return 0xff
end

local function tc()
    if state == "tc" then
        local i = xinfo
        if i.write then written[key(i.c, i.h, i.r)] = xfer end
        to_result({ (i.hd << 2) | i.unit, 0, 0, i.c, i.h, i.r, i.n })
    else
        errors[#errors + 1] = "terminal count in state " .. state
    end
end


local TRACE = opts.trace
local function tr(...) if TRACE then log[#log + 1] = string.format(...) end end
local M = { errors = errors, log = log, written = written }
function M.msr() local v = msr(); tr("  in msr -> %02x (%s)", v, state); return v end
function M.data_read() local v = data_read(); tr("  in data -> %02x", v); return v end
function M.data_write(v) tr("  out data %02x (%s)", v, state); data_write(v) end
M.tc = tc
function M.motor(on) motor = on end
function M.dump(dir)
    dir = dir and (dir .. "/") or ""
    local f = assert(io.open(dir .. "disk_out.txt", "w"))
    for k, v in pairs(written) do
        local c, h, id = k // 10000, (k // 100) % 100, k % 100
        local t = {}
        for i = 1, 256 do t[i] = string.format("%02x", v[i]) end
        f:write(string.format("%d %d %d %s\n", c, h, id, table.concat(t)))
    end
    f:close()
    f = assert(io.open(dir .. "fdc_log.txt", "w"))
    for _, l in ipairs(log) do f:write(l, "\n") end
    for _, e in ipairs(errors) do f:write("ERROR ", e, "\n") end
    f:close()
end
return M
end
