-- NEC PC-6001mkII machine model for z88dk-ticks, for programs that have the whole machine (zcc +pc6001 -subtype=mk2disc):
--     z88dk-ticks -b lua -lua pc6001mk2.lua -int 65000 ...        MK2_DISC=game.d88 for a disc
--
-- Memory: 64 KB of RAM, all of it readable and writable, as a program has it after the boot sector has mapped the ROM out ($F0 = $F1 = $DD, $F2 = $55); there is no ROM.  The bank
-- ports are kept but change nothing.  The video RAM is in the RAM: with $C1 bit 1 clear the base is {$8000, $C000, $0000, $4000} chosen by $B0 bits 2-1, and the 320x200 mode of two
-- bit planes (plane 0 at the base, plane 1 $2000 on, 40 bytes a pixel row, a pen = the plane 0 bit + 2 * the plane 1 bit) is drawn in the colour set $C0 & 7 by export_ppm().
--
-- Ports:
--     $90 read      the keyboard's code (the sub-CPU's ASCII byte): Mk2.key(code) sets it, and raises the keyboard interrupt (see below)
--     $A0 write     the PSG's register, $A1 its data (logged with the cycle count: Mk2.psg, Mk2.regs the registers now)
--     $B0, $C0, $C1, $C2, $F0, $F1, $F2, $F3, $F6, $F7   write: kept (Mk2.port[n]) and logged (Mk2.ports)
--     $D0-$D3       the PC-6031 disc unit on the 8255: Port A ($D0) data in, B ($D1) data out, C ($D2) the handshake (the unit's lines in bits 0-2: DAV, RFD, DAC; the program's
--                   outputs, set and reset through $D3, read back in bits 4-7: DAV, RFD, DAC, ATN).  The unit is a high level model of what the ROM's routines and z88dk's
--                   pc6001mk2_disk_* do: ATN and a command byte ($02 read, $01 write, $06 status, $03 data), then the parameters (count, drive, track, sector), the data, a status byte
--                   (bit 6 = good, bit 0 = an error).  The disc is a .d88 (MK2_DISC), a side of 40 tracks of 16 sectors of 256 bytes; Mk2.save_disc(path) writes it with what was written.
--     $F8 write     (not the machine's) 1 writes the PSG and port logs, 2 also the screen (mk2-screen.ppm), 3 also the disc (mk2-disc.d88)
--
-- Interrupts (IM 2, the mkII's): z88dk-ticks asks the model, with the global interrupt(cycles), whenever one could be taken (interrupts enabled) and a -int period has gone by, so -int sets
-- how often that is looked at (-int 2000 is fine) and not the timer's rate.  The model answers with the byte on the data bus, the low half of the vector: the timer's, the value
-- written to $F7 (the ROM's is $06), once every 4 MHz * ($F6 + 1) / 1950 cycles (61 Hz at $F6 = 31) while $B0 bit 0 is clear, and the keyboard's, $02, once for each Mk2.key(code).
-- The environment: MK2_KEYS ("cycles:code,cycles:code": at that many cycles the key code is sent, as Mk2.key does, noticed at the next interrupt poll), MK2_DISC, MK2_NO_DISC=1 (no unit answers: the status lines stay 0), MK2_OUTDIR (where the logs go).
-- The global table Mk2: .key(code), .ram(addr), .psg, .regs, .port, .ports, .disc (the unit: .sectors read and written), .dump(dir), .export_ppm(name), .save_disc(path), .now()

Mk2 = Mk2 or {}
local ram = {}
for i = 1, 0x10000 do ram[i] = 0 end
local now = 0
function Mk2.now() return now end
function Mk2.ram(addr) return ram[(addr & 0xffff) + 1] end

local port, ports = {}, {}
Mk2.port, Mk2.ports = port, ports
local psg_sel, psg, regs = 0, {}, {}
Mk2.psg, Mk2.regs = psg, regs
for i = 0, 15 do regs[i] = 0 end
local keycode = 0
local key_pending = false
function Mk2.key(code)
    keycode = code & 0xff
    if keycode ~= 0 then key_pending = true end
end

-- The disc: a .d88's sectors by (track, head 0, sector id)
local disc_data, sector_at = nil, {}
do
    local path = os.getenv("MK2_DISC")
    if path and not os.getenv("MK2_NO_DISC") then
        local f = assert(io.open(path, "rb"))
        disc_data = f:read("a")
        f:close()
        local off = 0x2b0
        while off + 16 <= #disc_data do
            local c, h, r = disc_data:byte(off + 1), disc_data:byte(off + 2), disc_data:byte(off + 3)
            local size = disc_data:byte(off + 15) | (disc_data:byte(off + 16) << 8)
            if h == 0 then sector_at[c * 256 + r] = off + 16 end
            off = off + 16 + size
        end
    end
end
local patched = {}                                  -- offsets in the image changed by a write: byte values
local unit = { reads = {}, writes = {}, errors = {} }
Mk2.disc = unit
local function get_sector(track, sector)
    local o = sector_at[track * 256 + sector]
    if not o then return nil end
    local t = {}
    for i = 1, 256 do t[i] = patched[o + i] or disc_data:byte(o + i) end
    return t
end
local function put_sector(track, sector, bytes)
    local o = sector_at[track * 256 + sector]
    if not o then return false end
    for i = 1, 256 do patched[o + i] = bytes[i] end
    return true
end
function Mk2.save_disc(path)
    local t = {}
    local n = 0
    local function flush() end
    local out = assert(io.open(path, "wb"))
    local chunk = {}
    for i = 1, #disc_data do
        chunk[#chunk + 1] = string.char(patched[i] or disc_data:byte(i))
        if #chunk == 4096 then out:write(table.concat(chunk)); chunk = {} end
    end
    out:write(table.concat(chunk))
    out:close()
end

-- The unit's side of the handshake.  H: the program's lines (set through $D3); D: the unit's (read in $D2 bits 0-2).
local H = { atn = false, dac = false, rfd = false, dav = false }
local D = { dav = false, rfd = false, dac = false }
local outbyte, inbyte = 0, 0
local mode, cmd, params, nparams = "idle", 0, {}, 0
local queue, qpos = {}, 0                           -- bytes the unit sends
local dataq = {}                                    -- what the last read made (command $03 sends it)
local wbuf, wneed = {}, 0
local status = 0x40

local function run_read()
    local count, track, sector = params[1], params[3], params[4]
    dataq = {}
    status = 0x40
    if not disc_data then status = 0x41 return end
    for k = 0, count - 1 do
        local s = sector + k
        local b = s <= 16 and get_sector(track, s) or nil
        if not b then
            status = 0x41
            unit.errors[#unit.errors + 1] = string.format("read: no sector track %d sector %d", track, s)
            break
        end
        for i = 1, 256 do dataq[#dataq + 1] = b[i] end
        unit.reads[#unit.reads + 1] = { track, s }
    end
end

local function run_write()
    local count, track, sector = params[1], params[3], params[4]
    status = 0x40
    for k = 0, count - 1 do
        local s = sector + k
        local b = {}
        for i = 1, 256 do b[i] = wbuf[k * 256 + i] end
        if s > 16 or not disc_data or not put_sector(track, s, b) then
            status = 0x41
            unit.errors[#unit.errors + 1] = string.format("write: no sector track %d sector %d", track, s)
            break
        end
        unit.writes[#unit.writes + 1] = { track, s }
    end
end

local function receive(b)                           -- a byte from the program has been taken
    if mode == "cmd" then
        cmd = b
        if cmd == 1 or cmd == 2 then mode, params, nparams = "params", {}, 0
        elseif cmd == 6 then mode, queue, qpos = "send", { status }, 0
        elseif cmd == 3 then mode, queue, qpos = "send", dataq, 0
        else mode = "idle" end
    elseif mode == "params" then
        nparams = nparams + 1
        params[nparams] = b
        if nparams == 4 then
            if cmd == 2 then run_read(); mode = "idle"
            else mode, wbuf, wneed = "wdata", {}, params[1] * 256 end
        end
    elseif mode == "wdata" then
        wbuf[#wbuf + 1] = b
        if #wbuf == wneed then run_write(); mode = "idle" end
    end
end

local function line_change(name, on)
    H[name] = on
    if name == "atn" and on then
        mode = "cmd"
        D.rfd = true                                -- ready for the command
    elseif name == "dav" and on and D.rfd then      -- a byte is on $D1
        D.rfd = false
        D.dac = true
        receive(outbyte)
    elseif name == "dav" and not on then
        D.dac = false
        if mode == "params" or mode == "wdata" then D.rfd = true end
    elseif name == "rfd" and on and mode == "send" and qpos < #queue then   -- the program asks for a byte
        qpos = qpos + 1
        inbyte = queue[qpos]
        D.dav = true
    elseif name == "dac" and on then
        D.dav = false
    elseif name == "dac" and not on and mode == "send" and qpos >= #queue then
        mode = "idle"
    end
end

local function portc()
    local v = (H.atn and 0x80 or 0) | (H.dac and 0x40 or 0) | (H.rfd and 0x20 or 0) | (H.dav and 0x10 or 0)
    if disc_data then
        v = v | (D.dac and 4 or 0) | (D.rfd and 2 or 0) | (D.dav and 1 or 0)
    end
    return v
end

-- The screen, in the 320x200 mode
local PALETTE = { 0x141414, 0xFFAC00, 0x00FFAC, 0xACFF00, 0xAC00FF, 0xFF00AC, 0x00ACFF, 0xACACAC, 0x141414, 0xFF0000, 0x00FF00, 0xFFFF00, 0x0000FF, 0xFF00FF, 0x00FFFF, 0xFFFFFF }
local PAL53 = { 0, 4, 1, 5, 2, 6, 3, 7, 8, 12, 9, 13, 10, 14, 11, 15, 10, 11, 12, 9, 15, 14, 13, 1, 10, 11, 12, 9, 15, 14, 13, 1 }
function Mk2.export_ppm(name)
    local base = ({ 0x8000, 0xC000, 0x0000, 0x4000 })[(((port[0xb0] or 0) >> 1) & 3) + 1]
    local set = (port[0xc0] or 0) & 7
    local f = assert(io.open(name .. ".ppm", "wb"))
    f:write("P6\n320 200\n255\n")
    for y = 0, 199 do
        local row = {}
        for x = 0, 39 do
            local a = base + y * 40 + x
            local p0, p1 = ram[(a & 0xffff) + 1], ram[((a + 0x2000) & 0xffff) + 1]
            for bit = 7, 0, -1 do
                local pen = ((p0 >> bit) & 1) | (((p1 >> bit) & 1) << 1)
                local rgb = PALETTE[PAL53[set * 4 + pen + 1] + 1]
                row[#row + 1] = string.char((rgb >> 16) & 255, (rgb >> 8) & 255, rgb & 255)
            end
        end
        f:write(table.concat(row))
    end
    f:close()
end

function Mk2.dump(dir)
    dir = dir or os.getenv("MK2_OUTDIR") or "."
    local f = assert(io.open(dir .. "/mk2-psg.txt", "w"))
    for _, e in ipairs(psg) do f:write(string.format("%d R%d=%02x\n", e[1], e[2], e[3])) end
    f:close()
    f = assert(io.open(dir .. "/mk2-ports.txt", "w"))
    f:write(table.concat(ports, "\n"), "\n")
    f:close()
    f = assert(io.open(dir .. "/mk2-disc.txt", "w"))
    for _, e in ipairs(unit.reads) do f:write(string.format("read %d %d\n", e[1], e[2])) end
    for _, e in ipairs(unit.writes) do f:write(string.format("write %d %d\n", e[1], e[2])) end
    for _, e in ipairs(unit.errors) do f:write(e, "\n") end
    f:close()
end

-- the timer: running when $B0 bit 0 is clear
local timer_next = nil
local function timer_period() return 4000000 * ((port[0xf6] or 0) + 1) / 1950 end
local events, next_event = {}, 1
for cycles, code in (os.getenv("MK2_KEYS") or ""):gmatch("(%d+):(%d+)") do events[#events + 1] = { tonumber(cycles), tonumber(code) } end
table.sort(events, function(a, b) return a[1] < b[1] end)
function interrupt(cycles)
    now = cycles
    while next_event <= #events and events[next_event][1] <= cycles do
        Mk2.key(events[next_event][2])
        next_event = next_event + 1
    end
    if timer_next and cycles >= timer_next then
        timer_next = timer_next + timer_period()
        if timer_next <= cycles then timer_next = cycles + timer_period() end
        return port[0xf7] or 6
    end
    if key_pending then
        key_pending = false
        return 2
    end
    return nil
end

function memory_read(addr, _type, cycles)
    now = cycles
    return ram[(addr & 0xffff) + 1]
end

function memory_write(addr, value, _type, cycles)
    now = cycles
    ram[(addr & 0xffff) + 1] = value
    return 0
end

function io_in(addr, st)
    now = st or now
    local p = addr & 0xff
    if p == 0x90 then return keycode
    elseif p == 0xd0 then return inbyte
    elseif p == 0xd2 then return portc()
    elseif p == 0xa2 then return regs[psg_sel & 15]
    end
    if Mk2.io_in then return Mk2.io_in(p, (addr >> 8) & 0xff, now) end
    return nil
end

function io_out(addr, value, st)
    now = st or now
    local p, v = addr & 0xff, value & 0xff
    if p == 0xa0 then psg_sel = v; return 0
    elseif p == 0xa1 then
        regs[psg_sel & 15] = v
        psg[#psg + 1] = { now, psg_sel & 15, v }
        return 0
    elseif p == 0xd1 then outbyte = v; return 0
    elseif p == 0xd3 then
        if v & 0x80 == 0 then                       -- bit set / reset
            local bit, on = (v >> 1) & 7, (v & 1) == 1
            local names = { [4] = "dav", [5] = "rfd", [6] = "dac", [7] = "atn" }
            if names[bit] and disc_data then line_change(names[bit], on) end
        end
        return 0
    elseif p == 0xb0 or p == 0xc0 or p == 0xc1 or p == 0xc2 or p == 0xf0 or p == 0xf1 or p == 0xf2 or p == 0xf3 or p == 0xf6 or p == 0xf7 then
        if p == 0xb0 then
            if v & 1 == 0 and (port[0xb0] or 1) & 1 == 1 then timer_next = now + timer_period()
            elseif v & 1 == 1 then timer_next = nil end
        end
        port[p] = v
        ports[#ports + 1] = string.format("%d $%02x=%02x", now, p, v)
        return 0
    elseif p == 0xf8 then
        if v >= 1 then Mk2.dump() end
        if v >= 2 then Mk2.export_ppm((os.getenv("MK2_OUTDIR") or ".") .. "/mk2-screen") end
        if v >= 3 and disc_data then Mk2.save_disc((os.getenv("MK2_OUTDIR") or ".") .. "/mk2-disc.d88") end
        return 0
    end
    if Mk2.io_out then return Mk2.io_out(p, v, now) or -1 end
    return -1
end

function memory_mmu_text()
    return string.format("PC-6001mkII $B0=%02X $C0=%02X $C1=%02X", port[0xb0] or 0, port[0xc0] or 0, port[0xc1] or 0)
end
