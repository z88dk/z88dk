-- A model of the WD1793 floppy controller (and the 1791/1797/2793 that behave alike), for z88dk-ticks or anything else that can call it from a port handler: the status register as it
-- is for the two kinds of command, restore and seek, read sector and write sector (one at a time), force interrupt, the DRQ and the busy flag that a program has to poll for, and one disc.
-- It checks as it goes (the sector exists, the track register is where the heads are, the drive is ready, a command is not given while the last is running, the data comes and goes
-- as asked) and collects what it did not like in .errors.
--
--   local fdc = require("wd1793")({ tracks = 40, sectors = 10, size = 512, image = "x.ldf", ready = function() return true end })
--   fdc.status()  fdc.track() fdc.sector() fdc.data_read()     the registers a program reads
--   fdc.command(v) fdc.set_track(v) fdc.set_sector(v) fdc.data_write(v)      and writes
--   fdc.dump(dir)       writes dir/disk_out.txt (the sectors written: "track sector hex") and dir/fdc_log.txt (the commands and the errors)
--
-- Options: tracks, sectors a track (numbered from 1), size (bytes a sector), image (a file of the sectors in a line: track by track, sector 1 first; without one, a pattern
-- of track, sector and position), ready (a function, true if the drive is ready: default always), busy_polls (status reads a seek or restore stays busy for: default 3), drq_polls
-- (status reads before a sector command's first data request: default 2), tracks_max (how far the heads can go: tracks + 2).
-- The commands that are not modelled (step, step in/out, read address, read and write track, multiple sectors) are errors.  A read of the data register with no request is not (the
-- chip gives the last byte) but a write of it is.  The head settling delay (the E bit) is counted: .settles is how many sector commands asked for it.
return function(opts)
opts = opts or {}
local TRACKS, SPT, SIZE = opts.tracks or 40, opts.sectors or 10, opts.size or 512
local BUSY_POLLS, DRQ_POLLS = opts.busy_polls or 3, opts.drq_polls or 2
local READY = opts.ready or function() return true end
local MAXTRACK = opts.tracks_max or (TRACKS + 2)

local image
if opts.image then
    local f = assert(io.open(opts.image, "rb"))
    image = f:read("a")
    f:close()
end
local function pattern(t, s, i) return (t * 7 + s * 29 + i) & 0xff end
local written = {}
local function key(t, s) return t * 100 + s end
local function sector_bytes(t, s)
    local w = written[key(t, s)]
    if w then return w end
    local out = {}
    if image then
        local off = (t * SPT + s - 1) * SIZE
        for i = 1, SIZE do out[i] = image:byte(off + i) or 0xe5 end
    else
        for i = 1, SIZE do out[i] = pattern(t, s, i - 1) end
    end
    return out
end

local M = { errors = {}, settles = 0, commands = {} }
local log = {}
local function note(s) log[#log + 1] = s end
local function err(s) M.errors[#M.errors + 1] = s; log[#log + 1] = "ERROR " .. s end

local trk, sec, dat = 0, 0, 0       -- the registers
local head = 0                      -- where the heads are
local busy, drq = false, false
local type1 = true                  -- the last command was a type I (restore, seek): the status bits differ
local rnf, lost, wfault = false, false, false
local seekerr = false
local pending_busy, pending_drq = 0, 0
local xfer, xpos, mode = nil, 0, nil
local index = 0

function M.status()
    if pending_busy > 0 then
        pending_busy = pending_busy - 1
        if pending_busy == 0 then busy = false end
    end
    if pending_drq > 0 then
        pending_drq = pending_drq - 1
        if pending_drq == 0 then drq = true end
    end
    local s = 0
    if not READY() then s = s | 0x80 end
    if busy then s = s | 0x01 end
    if type1 then
        index = index ~ 1
        s = s | (index << 1)
        if head == 0 then s = s | 0x04 end
        if seekerr then s = s | 0x10 end
        s = s | 0x20                -- head loaded
    else
        if drq then s = s | 0x02 end
        if lost then s = s | 0x04 end
        if rnf then s = s | 0x10 end
        if wfault then s = s | 0x20 end
    end
    return s
end
function M.track() return trk end
function M.sector() return sec end
function M.set_track(v) if busy then err("track register written while busy") end trk = v & 0xff end
function M.set_sector(v) if busy then err("sector register written while busy") end sec = v & 0xff end

function M.data_read()
    if mode == "read" and drq then
        dat = xfer[xpos + 1]
        xpos = xpos + 1
        drq = false
        if xpos >= SIZE then
            busy, mode = false, nil
            note("read done")
        else
            pending_drq = 1
        end
    elseif mode == "read" then
        -- a read before the next request: the program polls DRQ, so this is a mistake
        err("data register read with no request")
    end
    return dat
end

function M.data_write(v)
    v = v & 0xff
    if mode == "write" and drq then
        xpos = xpos + 1
        xfer[xpos] = v
        drq = false
        if xpos >= SIZE then
            written[key(M.cur_t, M.cur_s)] = xfer
            note(string.format("wrote track %d sector %d", M.cur_t, M.cur_s))
            busy, mode = false, nil
        else
            pending_drq = 1
        end
    elseif mode == "write" then
        err("data register written with no request")
    else
        dat = v     -- the data register: where a seek goes to
    end
end

local function finish_type1(target)
    type1 = true
    rnf, lost, wfault, seekerr = false, false, false, false
    drq = false
    busy = true
    pending_busy = BUSY_POLLS + 1
    mode = nil
end

function M.command(v)
    v = v & 0xff
    local top = v >> 4
    if v & 0xf0 == 0xd0 then            -- force interrupt: whatever was going on stops
        note(string.format("cmd %02x force interrupt", v))
        busy, drq, mode, pending_busy, pending_drq = false, false, nil, 0, 0
        type1 = true
        return
    end
    if busy then err(string.format("command %02x given while busy", v)) end
    M.commands[#M.commands + 1] = v
    if top == 0 then                    -- restore
        note(string.format("cmd %02x restore", v))
        finish_type1()
        head, trk = 0, 0
        if v & 8 == 0 then note("  (no head load)") end
    elseif top == 1 then                -- seek: the data register is where to go
        note(string.format("cmd %02x seek to %d (track register %d, heads at %d)", v, dat, trk, head))
        if trk ~= head then err(string.format("seek with the track register (%d) not where the heads are (%d)", trk, head)) end
        finish_type1()
        head = dat
        if head > MAXTRACK then err(string.format("seek to track %d: off the end", head)); head = MAXTRACK end
        trk = dat
    elseif top == 8 or top == 9 or top == 0xa or top == 0xb then      -- read and write sector
        local write = top >= 0xa
        local multi = (v & 0x10) ~= 0
        if multi then err(string.format("command %02x: multiple sectors are not modelled", v)) end
        if v & 0x04 ~= 0 then M.settles = M.settles + 1 end
        note(string.format("cmd %02x %s sector %d (track register %d, heads at %d)%s", v, write and "write" or "read", sec, trk, head, (v & 4 ~= 0) and " E" or ""))
        type1 = false
        rnf, lost, wfault = false, false, false
        if not READY() then
            note("  not ready")
            busy, drq = false, false
            return
        end
        if write and opts.write_protect then
            busy = false
            wfault = false
            return
        end
        if trk ~= head then
            err(string.format("sector command with the track register (%d) not where the heads are (%d)", trk, head))
            rnf, busy = true, false
            return
        end
        if sec < 1 or sec > SPT or head >= TRACKS then
            note(string.format("  record not found (track %d sector %d)", head, sec))
            rnf, busy = true, false
            return
        end
        busy = true
        M.cur_t, M.cur_s = head, sec
        if write then
            mode, xfer, xpos = "write", {}, 0
        else
            mode, xfer, xpos = "read", sector_bytes(head, sec), 0
        end
        pending_drq = DRQ_POLLS
    else
        err(string.format("command %02x is not modelled", v))
    end
end

function M.dump(dir)
    dir = dir or "."
    local f = assert(io.open(dir .. "/disk_out.txt", "w"))
    local keys = {}
    for k in pairs(written) do keys[#keys + 1] = k end
    table.sort(keys)
    for _, k in ipairs(keys) do
        local t, s = k // 100, k % 100
        local hex = {}
        for i, b in ipairs(written[k]) do hex[i] = string.format("%02x", b) end
        f:write(string.format("%d %d %s\n", t, s, table.concat(hex)))
    end
    f:close()
    local g = assert(io.open(dir .. "/fdc_log.txt", "w"))
    for _, l in ipairs(log) do g:write(l, "\n") end
    g:close()
end

return M
end
