-- Sharp MZ-800 model for z88dk-ticks: Takeda's memory banking, the GDG's 320x200 / 640x200 planar video RAM (write and read formats, scroll window), the palette, the display status
-- port, the 8253, the MB8876 floppy controller (inverted bus, D88 discs) and the keyboard matrix and joystick ports.  The PSG ($F2) and Z80 PIO writes are only logged.  The MZ-700
-- text screen is drawn for snapshots.
--
-- Environment:
--   MZ800_ROM     the 16 KB 9Z-504M monitor (ROM 1, character generator, ROM 2); without it ROM areas read $FF
--   MZ800_DISC    a .d88 image in drive 0 (writes are kept in memory and logged to disk_out.txt)
--   MZ800_SNAP    "cycles,...": write mz800-snap-<n>.ppm (the screen) at the first memory access after each
--   MZ800_PLANES  also write mz800-snap-<n>.planes (the four planes)
--   MZ800_PORTLOG write ports.txt: every write to $F2 and the other ports the model only logs
--   MZ800_OUTDIR  where files go (default .)
--   MZ800_KEYS    "cycles:key:down,...": key events (down 1 or 0): letters, digits, return, space, escape (BREAK), shift, control, left/right/up/down, f1-f5...;
--                 joy1_up/down/left/right/fire/fire2 and joy2_... for the joystick ports
-- A test can use the global table Mz800: now(), ram(addr), plane(n), palette, dmd, wf, rf, export_ppm(name), fdc (.log, .errors, .written), dump(dir), ports.
package.path = (os.getenv("ZCCCFG") or "") .. "/../ticks/?.lua;" .. package.path
local Matrix = require("keyboard_matrix")

Mz800 = Mz800 or {}

local ram, vram = {}, {}
for i = 1, 0x10000 do ram[i] = 0 end
for i = 1, 0x8000 do vram[i] = 0 end            -- four planes of $2000: plane n at n * $2000
local rom1, font, rom2 = {}, {}, {}
for i = 1, 0x1000 do rom1[i] = 0xff; font[i] = 0xff end
for i = 1, 0x2000 do rom2[i] = 0xff end
do
    local path = os.getenv("MZ800_ROM")
    if path then
        local f = assert(io.open(path, "rb"))
        local d = f:read("a")
        f:close()
        for i = 1, 0x1000 do rom1[i] = d:byte(i); font[i] = d:byte(0x1000 + i) end
        for i = 1, 0x2000 do rom2[i] = d:byte(0x2000 + i) or 0xff end
    end
end

local FRAME, LINE = 59736, 228
local OUTDIR = os.getenv("MZ800_OUTDIR") or "."
local now = 0

-- Memory banks (Takeda's mem_bank bits)
local MON_L, MON_H, CG_R, CG_W, VRAM = 1, 2, 4, 8, 16
local bank = MON_L | MON_H
local wf, rf, dmd = 1, 1, 0
local sof, sw, ssa, sea = 0, 125, 0, 125
local palette = { 0, 1, 2, 3 }
Mz800.palette = palette
local palette_sw = 0
local ports = {}
Mz800.ports = ports
local portlog = os.getenv("MZ800_PORTLOG") and assert(io.open((os.getenv("MZ800_OUTDIR") or ".") .. "/ports.txt", "w"))

local function vram_top() return (dmd & 4) ~= 0 and 0xbfff or 0x9fff end

-- the VRAM offset (within a plane) of a CPU address offset, with the scroll window
local function vram_addr(a)
    if dmd & 4 ~= 0 then
        if ssa * 128 <= a and a < sea * 128 then
            a = a + sof * 16
            if a >= sea * 128 then a = a - sw * 128 end
        end
    else
        if ssa * 64 <= a and a < sea * 64 then
            a = a + sof * 8
            if a >= sea * 64 then a = a - sw * 64 end
        end
    end
    return a
end

local function page_mask(f)
    local m = dmd & 7
    if m == 0 or m == 1 then return (f & 0x10) ~= 0 and 12 or 3
    elseif m == 2 then return 15
    elseif m == 4 or m == 5 then return (f & 0x10) ~= 0 and 4 or 1
    elseif m == 6 then return 5 end
    return 0
end

local function vram_write(a, v)
    a = vram_addr(a & 0x3fff) + 1
    local mode = wf & 0xe0
    local page
    if mode < 0x80 then
        page = (dmd & 4) ~= 0 and (wf & 5) or wf
        for i = 0, 3 do
            if page & (1 << i) ~= 0 then
                local k = a + i * 0x2000
                if mode == 0 then vram[k] = v
                elseif mode == 0x20 then vram[k] = vram[k] ~ v
                elseif mode == 0x40 then vram[k] = vram[k] | v
                else vram[k] = vram[k] & (~v & 0xff) end
            end
        end
    else
        page = page_mask(wf)
        for i = 0, 3 do
            if page & (1 << i) ~= 0 then
                local k = a + i * 0x2000
                if mode < 0xc0 then
                    vram[k] = (wf & (1 << i)) ~= 0 and v or 0
                elseif (wf & (1 << i)) ~= 0 then vram[k] = vram[k] | v
                else vram[k] = vram[k] & (~v & 0xff) end
            end
        end
    end
end

local function vram_read(a)
    a = vram_addr(a & 0x3fff) + 1
    if rf & 0x80 ~= 0 then
        local page = page_mask(rf)
        local result = 0xff
        for b2 = 0, 7 do
            local bit2 = 1 << b2
            for i = 0, 3 do
                if page & (1 << i) ~= 0 and (vram[a + i * 0x2000] & bit2) ~= ((rf & (1 << i)) ~= 0 and bit2 or 0) then
                    result = result & (~bit2 & 0xff)
                    break
                end
            end
        end
        return result
    end
    local page = page_mask(rf) & rf
    for i = 0, 3 do
        if page & (1 << i) ~= 0 then return vram[a + i * 0x2000] end
    end
    return 0xff
end

-- Timing: 59736 cycles a frame (262 lines of 228), the vertical blank from line 200
local function status_ce()
    local c = now % FRAME
    local line = c // LINE
    local hpos = c % LINE
    local vblank = line >= 200
    local hblank = hpos >= 160
    local vsync = line >= 240 and line < 244
    return (hblank and 0 or 0x80) | (vblank and 0 or 0x40) | 0x20 | (vsync and 0 or 0x10) | 2 | 0x0c | ((now // 112) & 1)
end

local snaps, snap_next, snap_n = {}, 1, 0
for c in (os.getenv("MZ800_SNAP") or ""):gmatch("(%d+)") do snaps[#snaps + 1] = tonumber(c) end

local function tick(cycles)
    now = cycles
    if snap_next <= #snaps and cycles >= snaps[snap_next] then
        snap_n = snap_n + 1
        snap_next = snap_next + 1
        Mz800.export_ppm(string.format("%s/mz800-snap-%d", OUTDIR, snap_n))
        if os.getenv("MZ800_PLANES") then
            local f = assert(io.open(string.format("%s/mz800-snap-%d.planes", OUTDIR, snap_n), "wb"))
            for i = 1, 0x8000 do f:write(string.char(vram[i])) end
            f:close()
            f = assert(io.open(string.format("%s/mz800-snap-%d.palette", OUTDIR, snap_n), "w"))
            f:write(string.format("dmd=%02x wf=%02x rf=%02x palette=%d,%d,%d,%d\n", dmd, wf, rf, palette[1], palette[2], palette[3], palette[4]))
            f:close()
        end
    end
end

-- The 8253 (ports $D4-$D7, also $E004-$E007 with the monitor ROM mapped).  Counter 0 runs at 1.1 MHz, counter 1 at 15.6 kHz (one a line) and counter 2 at the 1 s
-- tick of counter 1 (as on the MZ-700; the IPL's delay loops wait on counter 2 reaching a value).  Modes 2 and 3 reload, the others stop at 0.
local pit = {}
for i = 0, 2 do pit[i] = { reload = 0, at = 0, mode = 0, rw = 3, hi = false, latched = nil, loaded = false, wr_hi = false, tmp = 0 } end
local PIT_DIV = { [0] = 3.2, [1] = LINE, [2] = LINE * 15600 }
local function pit_value(i)
    local c = pit[i]
    if not c.loaded then return 0 end
    local r = c.reload == 0 and 65536 or c.reload
    local el = math.floor((now - c.at) / PIT_DIV[i])
    if c.mode == 2 or c.mode == 3 then return (r - (el % r)) & 0xffff end
    return math.max(r - el, 0) & 0xffff
end
local function pit_read(i)
    local c = pit[i]
    local v = c.latched or pit_value(i)
    if c.rw == 1 then c.latched = nil; return v & 0xff
    elseif c.rw == 2 then c.latched = nil; return v >> 8 end
    if c.hi then c.hi = false; c.latched = nil; return v >> 8 end
    c.hi = true
    c.latched = v
    return v & 0xff
end
local function pit_write(i, v)
    local c = pit[i]
    if c.rw == 1 then c.reload = v; c.loaded = true; c.at = now
    elseif c.rw == 2 then c.reload = v << 8; c.loaded = true; c.at = now
    elseif c.wr_hi then c.reload = c.tmp | (v << 8); c.wr_hi = false; c.loaded = true; c.at = now
    else c.tmp = v; c.wr_hi = true end
end
local function pit_ctrl(v)
    local i = (v >> 6) & 3
    if i == 3 then return end
    local c = pit[i]
    local rw = (v >> 4) & 3
    if rw == 0 then c.latched = pit_value(i); c.hi = false; return end
    c.rw, c.mode, c.hi, c.latched, c.wr_hi, c.loaded = rw, (v >> 1) & 7, false, nil, false, false
end

-- Memory as Takeda maps it (update_map_low/middle/high).  In MZ-700 mode (DMD bit 3: the state after reset, in which the IPL runs) the character generator is
-- paged by CG_R only and the text VRAM shows at $C000 (with CG_R) and $D000 (with MON_H); in MZ-800 mode CG_R or CG_W pages the generator in at $1000.
local tvc, tvd = {}, {}
for i = 1, 0x1000 do tvc[i] = 0; tvd[i] = 0 end

function memory_read(addr, _type, cycles)
    tick(cycles)
    addr = addr & 0xffff
    local m700 = dmd & 8 ~= 0
    if addr < 0x1000 then
        if bank & MON_L ~= 0 then return rom1[addr + 1] end
        return ram[addr + 1]
    elseif addr < 0x2000 then
        if bank & (m700 and CG_R or (CG_R | CG_W)) ~= 0 then return font[addr - 0x1000 + 1] end
        return ram[addr + 1]
    elseif m700 then
        if addr >= 0xc000 and addr < 0xd000 and bank & CG_R ~= 0 then return tvc[addr - 0xc000 + 1] end
        if addr >= 0xd000 and addr < 0xe000 and bank & MON_H ~= 0 then return tvd[addr - 0xd000 + 1] end
    elseif addr >= 0x8000 and addr <= vram_top() and bank & VRAM ~= 0 then
        return vram_read(addr - 0x8000)
    end
    if addr >= 0xe000 and bank & MON_H ~= 0 then
        if addr >= 0xe004 and addr < 0xe007 then return pit_read(addr - 0xe004) end
        if addr < 0xe009 then
            if addr == 0xe008 then return ((now % LINE) >= 160 and 0 or 0x80) | ((now // 112) & 1) | 0x7e end
            return 0xff
        end
        return rom2[addr - 0xe000 + 1] or 0xff
    end
    return ram[addr + 1]
end

function memory_write(addr, value, _type, cycles)
    tick(cycles)
    addr = addr & 0xffff
    local m700 = dmd & 8 ~= 0
    if addr < 0x1000 then
        if bank & MON_L == 0 then ram[addr + 1] = value end
    elseif addr < 0x2000 then
        if bank & (m700 and CG_R or (CG_R | CG_W)) == 0 then ram[addr + 1] = value end
    elseif m700 and addr >= 0xc000 and addr < 0xd000 and bank & CG_R ~= 0 then tvc[addr - 0xc000 + 1] = value
    elseif m700 and addr >= 0xd000 and addr < 0xe000 and bank & MON_H ~= 0 then tvd[addr - 0xd000 + 1] = value
    elseif not m700 and addr >= 0x8000 and addr <= vram_top() and bank & VRAM ~= 0 then
        vram_write(addr - 0x8000, value)
    elseif addr >= 0xe000 and bank & MON_H ~= 0 then
        if addr >= 0xe004 and addr < 0xe007 then pit_write(addr - 0xe004, value)
        elseif addr == 0xe007 then pit_ctrl(value) end   -- (ROM 2 and the 8255 are not written)
    else
        ram[addr + 1] = value
    end
    return 0
end

function Mz800.now() return now end
function Mz800.ram(a) return ram[(a & 0xffff) + 1] end
function Mz800.plane(n) local t = {} for i = 1, 0x2000 do t[i] = vram[n * 0x2000 + i] end return t end

-- The disc: a D88 image, sectors by (cylinder, head, record); everything the controller is asked is kept in .log
local fdc = { log = {}, errors = {}, written = {} }
Mz800.fdc = fdc
local disc = {}
local disc_loaded = false
do
    local path = os.getenv("MZ800_DISC")
    if path then
        local f = assert(io.open(path, "rb"))
        local d = f:read("a")
        f:close()
        for t = 0, 163 do
            local o = string.unpack("<I4", d, 0x21 + t * 4)
            if o ~= 0 then
                local pos = o + 1
                local ns = string.unpack("<I2", d, pos + 4)
                for _ = 1, ns do
                    local c, h, r = string.unpack("<BBB", d, pos)
                    local size = string.unpack("<I2", d, pos + 14)
                    local bytes = {}
                    for i = 1, size do bytes[i] = d:byte(pos + 16 + i - 1) end
                    disc[c * 1000 + h * 100 + r] = bytes
                    pos = pos + 16 + size
                end
            end
        end
        disc_loaded = true
    end
end
local logfile = assert(io.open(OUTDIR .. "/fdc_log.txt", "w"))
local function flog(s) fdc.log[#fdc.log + 1] = s; logfile:write(string.format("%d ", now), s, "\n"); logfile:flush() end
local function ferr(s) fdc.errors[#fdc.errors + 1] = s; flog("ERROR " .. s) end

-- registers as the chip has them (the bus inverts them: the CPU sees the complement)
local cmd, trkreg, secreg, datreg = 0, 0, 0, 0
local headpos = 0
local drive_reg, side = 0, 0
local motor_on_at = nil
local busy, drq, type1 = false, false, true
local rnf, lost, crcerr, seekerr = false, false, false, false
local mode, xfer, xpos, xnext = nil, nil, 0, 0
local cur_c, cur_h, cur_r
local busy_until = 0
local pending_rnf = false
local BYTE_CYCLES = 113
local index = 0

local function ready()
    return disc_loaded and motor_on_at ~= nil and now >= motor_on_at
end

local function fdc_status()
    if busy and mode == nil and now >= busy_until then
        busy = false
        if pending_rnf then rnf, pending_rnf = true, false end
    end
    if mode ~= nil and not drq and now >= xnext then
        drq = true
    end
    local s = 0
    if not ready() then s = s | 0x80 end
    if busy then s = s | 1 end
    if type1 then
        index = index ~ 1
        s = s | (index << 1) | 0x20
        if headpos == 0 then s = s | 4 end
        if seekerr then s = s | 0x10 end
    else
        if drq then s = s | 2 end
        if lost then s = s | 4 end
        if crcerr then s = s | 8 end
        if rnf then s = s | 0x10 end
    end
    return s
end

local function start_sector(c, h, r, write)
    local key = c * 1000 + h * 100 + r
    local bytes = fdc.written[key] or disc[key]
    if not bytes then
        -- the chip looks for the record for several turns of the disc (about 1 s), then sets record-not-found; a force interrupt before that ends it
        flog(string.format("record not found c=%d h=%d r=%d (after a search)", c, h, r))
        busy, mode, drq = true, nil, false
        busy_until = now + 1000000
        pending_rnf = true
        return false
    end
    cur_c, cur_h, cur_r = c, h, r
    if write then xfer, xpos = {}, 0 else xfer, xpos = bytes, 0 end
    mode = write and "write" or "read"
    drq = false
    xnext = now + 300
    return true
end

local function fdc_command(v)
    cmd = v
    local top = v >> 4
    if top == 0xd then
        flog(string.format("cmd %02x force interrupt", v))
        -- an interrupted command keeps its kind of status (Takeda); an idle chip shows the type I status
        if not busy then type1 = true end
        busy, drq, mode, pending_rnf = false, false, nil, false
        return
    end
    if busy then ferr(string.format("command %02x while busy", v)) end
    rnf, lost, crcerr, seekerr, pending_rnf = false, false, false, false, false
    if top < 8 then
        type1 = true
        if top == 0 then
            headpos, trkreg = 0, 0
            flog(string.format("cmd %02x restore", v))
        elseif top == 1 then
            flog(string.format("cmd %02x seek to %d (track register %d, heads at %d)", v, datreg, trkreg, headpos))
            headpos = datreg
            trkreg = datreg
            if v & 4 ~= 0 then
                local found = false
                for r = 1, 16 do if disc[headpos * 1000 + side * 100 + r] then found = true break end end
                if not found then seekerr = true end
            end
        else
            ferr(string.format("command %02x not modelled", v))
        end
        busy = true
        busy_until = now + 20000
        mode = nil
        return
    end
    type1 = false
    if top == 8 or top == 9 or top == 0xa or top == 0xb then
        local write = top >= 0xa
        flog(string.format("cmd %02x %s sector %d (track register %d, heads at %d, side %d)", v, write and "write" or "read", secreg, trkreg, headpos, side))
        if not ready() then flog("  not ready"); busy = false; return end
        if trkreg ~= headpos then ferr(string.format("sector command with track register %d, heads at %d", trkreg, headpos)) end
        busy = true
        start_sector(headpos, side, secreg, write)
        return
    end
    ferr(string.format("command %02x not modelled", v))
end

local function fdc_data_read()
    if mode == "read" then
        if not drq then
            if now >= xnext then drq = true else ferr("data register read with no request") end
        end
        local b = xfer[xpos + 1]
        xpos = xpos + 1
        drq = false
        xnext = now + BYTE_CYCLES
        if xpos >= #xfer then
            if cmd & 0x10 ~= 0 then       -- multiple sectors: on to the next record
                secreg = (secreg + 1) & 0xff
                if not start_sector(headpos, side, secreg, false) then flog("  multi read ran off the track") end
            else
                busy, mode = false, nil
            end
        end
        return b
    end
    return datreg
end

local function fdc_data_write(v)
    if mode == "write" then
        if not drq and now < xnext then ferr("data register written with no request") end
        xpos = xpos + 1
        xfer[xpos] = v
        drq = false
        xnext = now + BYTE_CYCLES
        if xpos >= 256 then
            fdc.written[cur_c * 1000 + cur_h * 100 + cur_r] = xfer
            flog(string.format("wrote c=%d h=%d r=%d", cur_c, cur_h, cur_r))
            Mz800.dump()
            if cmd & 0x10 ~= 0 then
                secreg = (secreg + 1) & 0xff
                if not start_sector(headpos, side, secreg, true) then end
            else
                busy, mode = false, nil
            end
        end
    else
        datreg = v
    end
end

function Mz800.dump(dir)
    dir = dir or OUTDIR
    local f
    f = assert(io.open(dir .. "/disk_out.txt", "w"))
    local keys = {}
    for k in pairs(fdc.written) do keys[#keys + 1] = k end
    table.sort(keys)
    for _, k in ipairs(keys) do
        local t = {}
        for i, b in ipairs(fdc.written[k]) do t[i] = string.format("%02x", (~b) & 0xff) end
        f:write(string.format("%d %d %d ", k // 1000, (k // 100) % 10, k % 100), table.concat(t), "\n")
    end
    f:close()
end

-- Keyboard: 8255 port A low nibble selects a column (0-9), port B returns its eight keys, active low
local matrix = Matrix.new(10, 8)
-- Takeda's key_map: rows are the 8255 strobes 0-9, bits 0-7 the keys read on port B
local ROWS = {
    [0] = { "return", ":", ";", nil, "tab", nil, nil, nil },
    { nil, nil, nil, "]", "[", "@", "z", "y" },
    { "x", "w", "v", "u", "t", "s", "r", "q" },
    { "p", "o", "n", "m", "l", "k", "j", "i" },
    { "h", "g", "f", "e", "d", "c", "b", "a" },
    { "8", "7", "6", "5", "4", "3", "2", "1" },
    { ".", ",", "9", "0", "space", "-", "^", "\\" },
    { "/", "_", "left", "right", "down", "up", "delete", "insert" },
    { "shift", nil, nil, nil, nil, nil, "control", "escape" },      -- (the key at the last place is BREAK)
    { nil, nil, nil, "f5", "f4", "f3", "f2", "f1" },
}
local KEYS = {}
for strobe = 0, 9 do
    for bit = 1, 8 do
        local name = ROWS[strobe][bit]
        if name then KEYS[name] = { strobe, bit - 1 } end
    end
end
Mz800.matrix = matrix
local col = 0
local events = {}
for cycles, name, down in (os.getenv("MZ800_KEYS") or ""):gmatch("(%d+):([^:,]+):(%d)") do
    events[#events + 1] = { tonumber(cycles), name, down == "1" }
end
table.sort(events, function(a, b) return a[1] < b[1] end)
-- Joysticks: the key names joy1_up, _down, _left, _right, _fire, _fire2 (and joy2_...) press a direction or button of the port read at $F0 (1) or $F1 (2): bits 0 up, 1 down, 2 left,
-- 3 right, 4 fire, 5 fire 2, a pressed one reading 0
local JOY = { up = 1, down = 2, left = 4, right = 8, fire = 16, fire2 = 32 }
local joy = { [1] = 0xff, [2] = 0xff }
local function apply_events()
    while #events > 0 and events[1][1] <= now do
        local e = table.remove(events, 1)
        local k = KEYS[e[2]]
        if k then matrix:set_key(k[1], k[2], e[3])
        else
            local port, dir = e[2]:match("^joy(%d)_(%a+)$")
            if port and JOY[dir] then
                local bit = JOY[dir]
                if e[3] then joy[tonumber(port)] = joy[tonumber(port)] & ~bit & 0xff else joy[tonumber(port)] = joy[tonumber(port)] | bit end
            end
        end
    end
end

-- The screen as the palette makes it (320x200 4 colours, planes I+II or III+IV; the other modes: plane I as 640 pixels)
local function rgb(c)
    local v = (c & 8) ~= 0 and 255 or 127
    if c == 8 then v = 127 end
    return ((c & 2) ~= 0) and v or 0, ((c & 4) ~= 0) and v or 0, ((c & 1) ~= 0) and v or 0
end
-- The MZ-700 text screen (DMD bit 3): characters at $D000 + 40 * row + column, attributes $800 above (bit 7 the second half of the generator, bits 4-6 the foreground, 0-2 the
-- background), the patterns from the generator RAM at $C000 (the IPL copies the ROM there), bit 0 the leftmost pixel
local function export_text(name)
    local f = assert(io.open(name .. ".ppm", "wb"))
    f:write("P6\n320 200\n255\n")
    local function colour(i) return string.char((i & 2) ~= 0 and 255 or 0, (i & 4) ~= 0 and 255 or 0, (i & 1) ~= 0 and 255 or 0) end
    for y = 0, 199 do
        local row = {}
        for x = 0, 39 do
            local p = (y >> 3) * 40 + x + 1
            local attr = tvd[0x800 + p]
            local code = (tvd[p] << 3) | ((attr & 0x80) << 4)
            local pat = tvc[code + (y & 7) + 1] or 0
            local fg, bg = colour((attr >> 4) & 7), colour(attr & 7)
            for bit = 0, 7 do row[#row + 1] = (pat >> bit) & 1 ~= 0 and fg or bg end
        end
        f:write(table.concat(row))
    end
    f:close()
end

function Mz800.export_ppm(name)
    if dmd & 8 ~= 0 then return export_text(name) end
    local f = assert(io.open(name .. ".ppm", "wb"))
    local wide = (dmd & 4) ~= 0
    local w = wide and 640 or 320
    f:write(string.format("P6\n%d 200\n255\n", w))
    local base = (dmd & 1) ~= 0 and 2 or 0
    for y = 0, 199 do
        local row = {}
        for x = 0, (wide and 79 or 39) do
            local a = vram_addr(y * (wide and 80 or 40) + x) + 1
            local p1, p2 = vram[a + base * 0x2000], vram[a + (base + 1) * 0x2000]
            for bit = 0, 7 do    -- (bit 0 is the leftmost pixel)
                local v = (p1 >> bit) & 1
                if not wide or (dmd & 6) == 6 then v = v | (((p2 >> bit) & 1) << 1) end
                local r, g, b = rgb(palette[v + 1])
                row[#row + 1] = string.char(r, g, b)
            end
        end
        f:write(table.concat(row))
    end
    f:close()
end

function io_in(addr, st)
    tick(st or now)
    local p = addr & 0xff
    if p == 0xce then return status_ce()
    elseif p == 0xd8 then return (~fdc_status()) & 0xff
    elseif p == 0xd9 then return (~trkreg) & 0xff
    elseif p == 0xda then return (~secreg) & 0xff
    elseif p == 0xdb then return (~fdc_data_read()) & 0xff
    elseif p >= 0xd4 and p <= 0xd6 then return pit_read(p - 0xd4)
    elseif p == 0xd1 then apply_events(); return matrix:read(col)
    elseif p == 0xe0 then bank = (bank & ~CG_W) | CG_R | VRAM; return 0xff
    elseif p == 0xe1 then bank = bank & ~(CG_R | CG_W | VRAM); return 0xff
    elseif p == 0xf0 then apply_events(); return joy[1]
    elseif p == 0xf1 then apply_events(); return joy[2]
    end
    return nil
end

function io_out(addr, value, st)
    tick(st or now)
    local p, v = addr & 0xff, value & 0xff
    if p == 0xcc then wf = v
    elseif p == 0xcd then rf = v
    elseif p == 0xce then dmd = v
    elseif p == 0xcf then
        local hi = (addr >> 8) & 0xff
        if hi == 1 then sof = (sof & 0xf00) | v
        elseif hi == 2 then sof = (sof & 0x0ff) | ((v & 3) << 8)
        elseif hi == 3 then sw = v & 0x7f
        elseif hi == 4 then ssa = v & 0x7f
        elseif hi == 5 then sea = v & 0x7f end
    elseif p == 0xf0 then
        if portlog then portlog:write(string.format("%d out $f0,$%02x (palette)\n", now, v)); portlog:flush() end
        if v & 0x40 ~= 0 then palette_sw = (v & 3) << 2
        else palette[((v >> 4) & 3) + 1] = v & 0x0f end
    elseif p == 0xe0 then bank = bank & ~(MON_L | CG_R | CG_W)
    elseif p == 0xe1 then bank = bank & ~MON_H
    elseif p == 0xe2 then bank = bank | MON_L
    elseif p == 0xe3 then bank = bank | MON_H
    elseif p == 0xe4 then bank = (bank | MON_L | MON_H | CG_W | VRAM) & ~CG_R
    elseif p == 0xe5 or p == 0xe6 then -- PCG: MZ-700 mode only
    elseif p == 0xd8 then fdc_command((~v) & 0xff)
    elseif p == 0xd9 then trkreg = (~v) & 0xff
    elseif p == 0xda then secreg = (~v) & 0xff
    elseif p == 0xdb then
        if mode == "write" then fdc_data_write((~v) & 0xff) else datreg = (~v) & 0xff end
    elseif p == 0xdc then
        drive_reg = v
        if v & 0x80 ~= 0 then
            if motor_on_at == nil then motor_on_at = now + 560000 end
        else motor_on_at = nil end
    elseif p == 0xdd then side = v & 1   -- as Takeda: the IPL sends $FF for logical side 0, which is head 1 of the D88 image (as for the MZ-2500)
    elseif p == 0xde or p == 0xdf then -- density, DRQ interrupt
    elseif p == 0xd0 then col = v & 0x0f
    elseif p >= 0xd4 and p <= 0xd6 then pit_write(p - 0xd4, v)
    elseif p == 0xd7 then pit_ctrl(v)
    elseif p >= 0xd1 and p <= 0xd3 or p == 0xf1 or p == 0xf2 or p >= 0xfc then
        local line = string.format("%d out $%02x,$%02x", now, p, v)
        ports[#ports + 1] = line
        if portlog then portlog:write(line, "\n"); portlog:flush() end
    else
        return -1
    end
    return 0
end

function memory_mmu_text()
    return string.format("MZ-800 bank=%02X dmd=%02X wf=%02X rf=%02X", bank, dmd, wf, rf)
end
function memory_has_banks() return false end
function memory_bank_store(_bank, _offset, _value) return -1 end
function memory_banked_pc(_pc) return nil end
function memory_banked_caller(_saved, _ret) return nil end
function memory_reset_paging() bank = MON_L | MON_H end
