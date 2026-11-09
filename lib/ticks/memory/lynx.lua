-- Camputers Lynx 128K machine model for z88dk-ticks: z88dk-ticks -b lua -lua lynx.lua -int 120000 ...   (the frame interrupt is the 6845's VSYNC, 50 Hz: 120000 cycles at 6 MHz)
--
-- Memory: the 128K's banking as MAME's camplynx.cpp has it (port $82).  The RAM is 64 KB of user RAM, four 16 KB video planes that alias the CPU's addresses ($0000 red, $4000 blue,
-- $8000 green, $C000 alternate green: a write goes to the plane at the same address) and a fourth 64 KB; port $82 chooses which a read comes from and which are written (bit 7 writes
-- user RAM, 6 the video planes, 5 the third bank, 4 the fourth; bits 3 to 0, inverted with bits 3 and 2, read ROM, user RAM, video RAM, the fourth bank).  The modes the games use:
--     $08   user RAM is read and written (what the ROM leaves for a program that has the machine)
--     $C8   the video planes are written, user RAM is read: the drawing window (a program that draws in it must not use the stack: nothing is written to RAM)
--     $0E   the video planes are read, user RAM is written: a copy of the screen into RAM, run from video memory
-- The model starts in $08 (not the reset state, ROM at $0000-$5FFF) so that a program loaded by ticks runs: ticks loads it through the memory hooks.  There is no ROM
-- unless LYNX_ROM names a file of the eight 8 KB ROM banks (64 KB); without one a ROM read gives $FF.
--
-- Ports (the high byte is ignored but for the keyboard):
--     $50-$53 read, $54-$57 write   the WD1793 (z88dk's lib/ticks/wd1793.lua) on a disk of 40 tracks of 10 sectors of 512 bytes, single sided: LYNX_DISC is a raw .ldf
--     $58 write     bit 0-1 the drive, bit 2 the side, bit 3 the motor (1 = off), bit 4 selects the ROM page for bank 7.  The drive is ready when the motor is on (after LYNX_SPINUP
--                   status reads: default 5), a disk is in (LYNX_NO_DISC=1: none)
--     $80 write     the control port (bit 4 shows the alternate green plane, bit 3 the cassette: the DAC goes to the tape, so a program wanting the speaker clears it)
--     $0n80 read    keyboard line n (0 to 9), active low: Lynx.key("a", true)
--     $82 write     the bank port.  $82 read: $FB
--     $84 write     the 6 bit DAC: logged with the cycle count (Lynx.dac: { cycles, value }); with the cassette on it is the tape's output and not logged
--     $86, $87      the 6845's address and data registers (kept: Lynx.crtc)
--     $F0 write     (not the machine's) 1 writes the logs, 2 also the screen, 3 also the planes, as dump(), export_ppm() and export_planes() do
--
-- The environment: LYNX_DISC, LYNX_NO_DISC, LYNX_SPINUP, LYNX_FDC_BUSY (the controller's busy polls), LYNX_OUTDIR (where the logs go: default the current directory),
-- LYNX_EAGER (write the port and error logs at every port write, for a run that ends at an address, not by a write to $F0), LYNX_ROM, LYNX_KEYS (key events:
-- "cycles:key:1,cycles:key:0,...": at that many cycles the key goes down (1) or up (0), as Lynx.key has it, applied when the keyboard is next read),
-- LYNX_SNAP ("cycles,cycles,...": write lynx-snap-<n>.ppm, the screen, at the first memory access after each: for a run that ends by a cycle count).
--
-- A test can hook in: the global table Lynx has
--     Lynx.io_in(port, high, cycles) / Lynx.io_out(port, value, cycles)   called for a port the model does not know: a value or nil / 0 if it took the write
--     Lynx.key(name, down)        press or release a key: a character as the keyboard has it (letters in lower case, "shift", "return", "space", "up", "down", "left", "right",
--                                 "escape", "delete", "control"), or Lynx.set_key(line, bit, down)
--     Lynx.now()                  the cycles run so far, as of the last memory access or port access
--     Lynx.ram(i)                 byte i of the 320 KB of RAM (user RAM from $10000, the planes from $20000: red, blue, green, alternate green)
--     Lynx.plane(n)               plane n (0 red, 1 blue, 2 green, 3 alternate green) as a table of 16384 bytes (1 based)
--     Lynx.user(addr)             a byte of the user RAM
--     Lynx.fdc                    the disk controller model (.errors, .settles, .commands)
--     Lynx.dump(dir)              the disk log, the sectors written, the ports log, the DAC log and the controller's errors
--     Lynx.export_planes(name)    name.bin: the four planes, 16 KB each;  Lynx.export_ppm(name): name.ppm, the 512 x 252 screen
package.path = (os.getenv("ZCCCFG") or "") .. "/../ticks/?.lua;" .. package.path
local Matrix = require("keyboard_matrix")

Lynx = Lynx or {}
local RAM_SIZE = 0x50000
local ram = {}
for i = 1, RAM_SIZE do ram[i] = 0 end
Lynx.ram = function(i) return ram[i + 1] end

local rom
do
    local path = os.getenv("LYNX_ROM")
    if path then
        local f = assert(io.open(path, "rb"))
        rom = f:read("a")
        f:close()
    end
end

local port58, port80, port82 = 0, 0, 0x08
local rbase = {}            -- for each 8 KB of the CPU's space: where a read comes from (an index into ram), or -1 for the ROM and its bank
local wbyte = 1
local now = 0

-- Port $82 as MAME's port82_w: the banks (entries of 8 KB: 0-7 the ROM, 8-15 user RAM, 16-23 video, 24-31 the third bank, 32-39 the fourth)
local function set_banks(v)
    port82 = v & 0xff
    local d = port82 ~ 0x8c
    wbyte = ((d >> 7) & 1) | (((d >> 6) & 1) << 1) | (((d >> 5) & 1) << 2) | (((d >> 4) & 1) << 3)
    local r = (((d >> 0) & 1) << 3) | (((d >> 1) & 1) << 2) | (((d >> 2) & 1) << 1) | ((d >> 3) & 1)
    if r & 2 ~= 0 then r = r & 7 end
    local entries
    local last = ((port58 >> 4) & 1) == 1 and 15 or 7
    local function seq(e0) local t = {} for i = 0, 7 do t[i + 1] = e0 + i end return t end
    if r == 0 or r == 1 then entries = seq(0)
    elseif r == 2 or r == 0x0a then entries = seq(8)
    elseif r == 3 or r == 7 or r == 0x0b or r == 0x0f then entries = { 0, 1, 2, 11, 12, 13, 14, last }
    elseif r == 4 or r == 6 or r == 0x0c or r == 0x0e then entries = seq(16)
    elseif r == 5 or r == 0x0d then entries = { 0, 1, 2, 19, 20, 21, 22, 23 }
    elseif r == 8 then entries = seq(32)
    elseif r == 9 then entries = { 0, 1, 2, 35, 36, 37, 38, 39 }
    else error(string.format("Lynx: banking code %02X not handled", port82)) end
    for i = 1, 8 do
        local e = entries[i]
        rbase[i] = e < 8 and -1 or e * 0x2000
    end
end
set_banks(0x08)

local snaps, snap_next, snap_n = {}, 1, 0
for c in (os.getenv("LYNX_SNAP") or ""):gmatch("(%d+)") do snaps[#snaps + 1] = tonumber(c) end

function memory_read(addr, _type, cycles)
    now = cycles
    if snap_next <= #snaps and cycles >= snaps[snap_next] then
        snap_n = snap_n + 1
        snap_next = snap_next + 1
        Lynx.export_ppm(string.format("%s/lynx-snap-%d", os.getenv("LYNX_OUTDIR") or ".", snap_n))
    end
    addr = addr & 0xffff
    local base = rbase[(addr >> 13) + 1]
    if base < 0 then
        if rom then return rom:byte(addr + 1) or 0xff end
        return 0xff
    end
    return ram[base + (addr & 0x1fff) + 1]
end

function memory_write(addr, value, _type, cycles)
    now = cycles
    addr = addr & 0xffff
    local w = wbyte
    if w & 1 ~= 0 then ram[0x10000 + addr + 1] = value end
    if w & 2 ~= 0 then ram[0x20000 + addr + 1] = value end
    if w & 4 ~= 0 then ram[0x30000 + addr + 1] = value end
    if w & 8 ~= 0 then ram[0x40000 + addr + 1] = value end
    return 0
end

function Lynx.now() return now end
function Lynx.user(addr) return ram[0x10000 + (addr & 0xffff) + 1] end
function Lynx.plane(n)
    local t = {}
    local b = 0x20000 + n * 0x4000
    for i = 1, 0x4000 do t[i] = ram[b + i] end
    return t
end

-- The keyboard: ten lines of eight keys, active low
local matrix = Matrix.new(10, 8)
local KEYS = {                                  -- {line, bit}: as the machine's lines are (MAME's LINE0 to LINE9)
    ["1"] = { 0, 0 }, up = { 0, 4 }, down = { 0, 5 }, escape = { 0, 6 }, shift = { 0, 7 },
    ["3"] = { 1, 0 }, ["4"] = { 1, 1 }, e = { 1, 2 }, x = { 1, 3 }, d = { 1, 4 }, c = { 1, 5 },
    ["2"] = { 2, 0 }, q = { 2, 1 }, w = { 2, 2 }, z = { 2, 3 }, s = { 2, 4 }, a = { 2, 5 }, control = { 2, 6 },
    ["5"] = { 3, 0 }, r = { 3, 1 }, t = { 3, 2 }, v = { 3, 3 }, g = { 3, 4 }, f = { 3, 5 },
    ["6"] = { 4, 0 }, y = { 4, 1 }, h = { 4, 2 }, space = { 4, 3 }, [" "] = { 4, 3 }, n = { 4, 4 }, b = { 4, 5 },
    ["7"] = { 5, 0 }, ["8"] = { 5, 1 }, u = { 5, 2 }, m = { 5, 3 }, j = { 5, 5 },
    ["9"] = { 6, 0 }, i = { 6, 1 }, o = { 6, 2 }, [","] = { 6, 3 }, k = { 6, 5 },
    ["0"] = { 7, 0 }, p = { 7, 1 }, l = { 7, 2 }, ["."] = { 7, 3 }, [";"] = { 7, 5 },
    ["-"] = { 8, 0 }, ["@"] = { 8, 1 }, ["["] = { 8, 2 }, ["/"] = { 8, 3 }, [":"] = { 8, 5 },
    delete = { 9, 0 }, ["]"] = { 9, 1 }, left = { 9, 2 }, ["return"] = { 9, 3 }, right = { 9, 5 },
}
function Lynx.set_key(line, bit, down) matrix:set_key(line, bit, down) end
function Lynx.key(name, down)
    local k = KEYS[name]
    if not k then error("Lynx.key: no key " .. tostring(name)) end
    matrix:set_key(k[1], k[2], down ~= false)
end
local events, next_event = {}, 1
for cycles, name, down in (os.getenv("LYNX_KEYS") or ""):gmatch("(%d+):([^:,]+):(%d)") do
    events[#events + 1] = { tonumber(cycles), name, down == "1" }
end
table.sort(events, function(a, b) return a[1] < b[1] end)
local function apply_events()
    while next_event <= #events and events[next_event][1] <= now do
        Lynx.key(events[next_event][2], events[next_event][3])
        next_event = next_event + 1
    end
end

-- The disk
local SPINUP = tonumber(os.getenv("LYNX_SPINUP") or "5")
local spin = 0
local function ready()
    if os.getenv("LYNX_NO_DISC") then return false end
    if port58 & 8 ~= 0 then return false end
    return spin <= 0
end
local fdc = require("wd1793")({ tracks = 40, sectors = 10, size = 512, image = os.getenv("LYNX_DISC"), ready = ready,
                                busy_polls = tonumber(os.getenv("LYNX_FDC_BUSY") or "3") })
Lynx.fdc = fdc
local fdc_status = fdc.status
fdc.status = function()
    if port58 & 8 == 0 and spin > 0 then spin = spin - 1 end
    return fdc_status()
end

local ports, dac = {}, {}
Lynx.dac = dac
Lynx.ports = ports
Lynx.crtc = {}
local crtc_sel = 0

local function eager()
    if not os.getenv("LYNX_EAGER") then return end
    local dir = os.getenv("LYNX_OUTDIR") or "."
    local f = assert(io.open(dir .. "/ports_log.txt", "w")); f:write(table.concat(ports, "\n"), "\n"); f:close()
    local e = assert(io.open(dir .. "/fdc_errors.txt", "w")); e:write(table.concat(fdc.errors, "\n"), "\n"); e:close()
end

function Lynx.dump(dir)
    dir = dir or os.getenv("LYNX_OUTDIR") or "."
    fdc.dump(dir)
    local f = assert(io.open(dir .. "/ports_log.txt", "w")); f:write(table.concat(ports, "\n"), "\n"); f:close()
    local d = {}
    for i, e in ipairs(dac) do d[i] = e[1] .. " " .. e[2] end
    f = assert(io.open(dir .. "/dac_out.txt", "w")); f:write(table.concat(d, "\n"), "\n"); f:close()
    local e = assert(io.open(dir .. "/fdc_errors.txt", "w")); e:write(table.concat(fdc.errors, "\n"), "\n"); e:close()
end

function Lynx.export_planes(name)
    local f = assert(io.open(name .. ".bin", "wb"))
    for p = 0, 3 do
        local chunk = {}
        for i = 1, 0x4000 do
            chunk[#chunk + 1] = string.char(ram[0x20000 + p * 0x4000 + i])
            if #chunk == 1024 then f:write(table.concat(chunk)); chunk = {} end
        end
    end
    f:close()
end

-- the screen: 512 x 252, a row 64 bytes from $0100 (the first four rows of the 6845's display are not shown); pen = blue * 4 + green * 2 + red
function Lynx.export_ppm(name)
    local green = 0x28000 + ((port80 & 0x10) ~= 0 and 0x4000 or 0)
    local f = assert(io.open(name .. ".ppm", "wb"))
    f:write("P6\n512 252\n255\n")
    for y = 0, 251 do
        local row = {}
        for x = 0, 63 do
            local a = 0x100 + y * 64 + x + 1
            local r, b, g = ram[0x20000 + a], ram[0x24000 + a], ram[green + a]
            for bit = 7, 0, -1 do
                local pen = (((b >> bit) & 1) << 2) | (((g >> bit) & 1) << 1) | ((r >> bit) & 1)
                row[#row + 1] = string.char(((pen & 1) ~= 0) and 255 or 0, ((pen & 2) ~= 0) and 255 or 0, ((pen & 4) ~= 0) and 255 or 0)
            end
        end
        f:write(table.concat(row))
    end
    f:close()
end

function io_in(addr, st)
    now = st or now
    local p = addr & 0xff
    if p == 0x50 then return fdc.status()
    elseif p == 0x51 then return fdc.track()
    elseif p == 0x52 then return fdc.sector()
    elseif p == 0x53 then return fdc.data_read()
    elseif p == 0x80 then apply_events(); return matrix:read((addr >> 8) & 0x0f)
    elseif p == 0x82 then return 0xfb
    elseif p == 0x86 then return 0
    elseif p == 0x87 then return Lynx.crtc[crtc_sel] or 0
    end
    if Lynx.io_in then return Lynx.io_in(p, (addr >> 8) & 0xff, now) end
    return nil
end

function io_out(addr, value, st)
    now = st or now
    local p, v = addr & 0xff, value & 0xff
    if p == 0x54 then fdc.command(v); return 0
    elseif p == 0x55 then fdc.set_track(v); return 0
    elseif p == 0x56 then fdc.set_sector(v); return 0
    elseif p == 0x57 then fdc.data_write(v); return 0
    elseif p == 0x58 then
        if (port58 & 8) ~= 0 and (v & 8) == 0 then spin = SPINUP end
        if (v & 8) ~= 0 then spin = 0 end
        local changed = ((port58 ~ v) & 0x10) ~= 0
        port58 = v
        ports[#ports + 1] = string.format("%d $58=%02x", now, v)
        if changed then set_banks(port82) end
        eager()
        return 0
    elseif p == 0x80 then
        port80 = v
        ports[#ports + 1] = string.format("%d $80=%02x", now, v)
        eager()
        return 0
    elseif p == 0x82 then
        set_banks(v)
        ports[#ports + 1] = string.format("%d $82=%02x", now, v)
        eager()
        return 0
    elseif p == 0x84 then
        if port80 & 8 == 0 then dac[#dac + 1] = { now, v } end
        return 0
    elseif p == 0x86 then crtc_sel = v & 0x1f; return 0
    elseif p == 0x87 then Lynx.crtc[crtc_sel] = v; return 0
    elseif p == 0xf0 then
        if v >= 1 and v <= 3 then Lynx.dump() end
        if v >= 2 then Lynx.export_ppm((os.getenv("LYNX_OUTDIR") or ".") .. "/lynx-screen") end
        if v == 3 then Lynx.export_planes((os.getenv("LYNX_OUTDIR") or ".") .. "/lynx-planes") end
        return 0
    end
    if Lynx.io_out then return Lynx.io_out(p, v, now) or -1 end
    return -1
end

function memory_mmu_text()
    return string.format("Lynx port82=%02X port58=%02X port80=%02X", port82, port58, port80)
end
