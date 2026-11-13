-- Samsung SPC-1500 model for z88dk-ticks: 64 KB of RAM with the IPL ROM
-- overlaid on reads at $0000-$7FFF (I/O ports $1D00 and $1E00), and the I/O
-- space as MAME's samsung/spc1500.cpp has it (the whole 16 bit port address
-- is decoded): the three bit planes at $4000/$8000/$C000 (blue, red, green:
-- 16 KB each, 40 or 80 bytes a pixel row, the 8 lines of a character row
-- $800 apart), the text attribute and character RAM ($2000, $3000: kept, not
-- drawn), the palette ($1000, $1100, $1200) and priority ($1300) registers,
-- the 6845's registers ($1800/$1801), the keyboard matrix ($1900 + row, a
-- key down a 1 bit), the 8255 ($1A00-$1A03: port B bit 7 is the vertical
-- blank, port C and the bit set/reset kept, the double access mode of port C
-- bit 5), the AY-3-8910 ($1C00 address, $1B00 data; its port A, register 14,
-- is the joystick, active low).
--
-- Environment:
--   SPC1500_ROM       the 32 KB IPL ROM (ipl.rom of MAME's romset);
--                     without it the ROM reads $FF.  The ROM starts
--                     selected only with SPC1500_IPL=1 (otherwise RAM is:
--                     a program loaded at 0)
--   SPC1500_SNAP      "cycles,...": write spc1500-snap-<n>.ppm (the
--                     screen) at the first memory access after each
--   SPC1500_PLANES    also write spc1500-snap-<n>.planes (the three
--                     planes, 16 KB each) and .regs (the palette, priority
--                     and CRTC registers)
--   SPC1500_PORTLOG   write ports.txt: every write to the AY and port C,
--                     with its time
--   SPC1500_OUTDIR    where files go (default .)
--   SPC1500_TAPE      a cassette to play: a MAME .tap (one byte, '0' or
--                     '1', a bit: a zero is 4 low then 4 high samples at
--                     17 kHz, a one 9 and 9); the deck is "playing" when
--                     there is one, and the tape runs while the motor is on
--                     (the relay flips on each low pulse of the AY
--                     register 15's bit 7, as MAME's driver has it)
--   SPC1500_TAPE_OUT  record the cassette output (the 8255's port C bit 0,
--                     low while it is 1) to a .tap: a bit is a one if the
--                     high level lasts over 1200 T-states, while the motor
--                     is on
--   SPC1500_KEYS      "cycles:key:down,...": key events (down 1 or 0):
--                     letters, digits, return, space, escape, backspace,
--                     shift, control, left/right/up/down, f1-f5, and the
--                     punctuation as typed ("=", "-", ";", ",", ".", "/",
--                     "[", "]", "'", "`", "\\"); joy_up/down/left/right/
--                     fire/fire2 for the AY's port A
-- A test can use the global table Spc1500: now(), ram(addr), plane(n), pal,
-- prio, crtc, ay (the registers) and aylog, portc, export_ppm(name), matrix,
-- rom_selected().
local Spc1500 = {}
_G.Spc1500 = Spc1500

local ram, vram, text = {}, {}, {}
for i = 1, 0x10000 do ram[i] = 0 end
for i = 1, 0xC000 do vram[i] = 0 end           -- the three planes of $4000: plane n at n * $4000
for i = 1, 0x2000 do text[i] = 0 end
local rom = {}
for i = 1, 0x8000 do rom[i] = 0xff end
do
    local path = os.getenv("SPC1500_ROM")
    if path then
        local f = assert(io.open(path, "rb"))
        local d = f:read("a")
        f:close()
        for i = 1, 0x8000 do rom[i] = d:byte(i) or 0xff end
    end
end
local rom_on = os.getenv("SPC1500_IPL") == "1"

local FRAME = 66667                             -- 4 MHz / 60: the vertical blank bit is low for the last eighth
local OUTDIR = os.getenv("SPC1500_OUTDIR") or "."
local now = 0

local pal = { 0, 0, 0 }                         -- the palette registers (blue, red, green)
local prio = 0
local crtc, crtc_index = {}, 0
for i = 0, 17 do crtc[i] = 0 end
local portc, p5 = 0, 0
local double_mode = false
local ay, ay_index, aylog = {}, 0, {}
for i = 0, 15 do ay[i] = 0 end
ay[7] = 0xbf                                   -- (the mixer as the IPL leaves it: port A in, port B out)
ay[15] = 0xbf                                  -- (port B as the IPL leaves it: the relay's bit 7 high, the IPL ROM selected)
Spc1500.pal, Spc1500.crtc, Spc1500.ay, Spc1500.aylog = pal, crtc, ay, aylog
local portlog = os.getenv("SPC1500_PORTLOG") and assert(io.open(OUTDIR .. "/ports.txt", "w"))
local function plog(s) if portlog then portlog:write(string.format("%d ", now), s, "\n"); portlog:flush() end end

-- The keyboard matrix: row n is read at $1900 + n, a key down a 1 bit
local ROWS = {
    [0] = { nil, "shift", "control", nil, "break", "\\", "graph", nil },
    { "=", "right", "space", "return", "c", "a", "q", "1" },
    { "caps", "left", "z", "]", "v", "s", "w", "2" },
    { "backspace", "up", "escape", "`", "b", "d", "e", "3" },
    { "delins", "down", "tab", "home", "n", "f", "r", "4" },
    { nil, "f1", nil, nil, "m", "g", "t", "5" },
    { nil, "f2", "[", "x", ",", "h", "y", "6" },
    { nil, "f3", nil, "p", ".", "j", "u", "7" },
    { nil, "f4", nil, "'", "/", "k", "i", "8" },
    { "hangul", "f5", "-", "0", ";", "l", "o", "9" },
}
local KEYS = {}
local matrix = {}
for row = 0, 9 do
    matrix[row] = 0
    for bit = 1, 8 do
        local name = ROWS[row][bit]
        if name then KEYS[name] = { row, bit - 1 } end
    end
end
Spc1500.matrix = matrix
local JOY = { up = 1, down = 2, left = 4, right = 8, fire = 0x20, fire2 = 0x40 }     -- the AY's port A bits, a pressed one reading 0
local joy = 0xff
local events = {}
for cycles, name, down in (os.getenv("SPC1500_KEYS") or ""):gmatch("(%d+):([^:,]+):(%d)") do
    events[#events + 1] = { tonumber(cycles), name, down == "1" }
end
table.sort(events, function(a, b) return a[1] < b[1] end)
local function apply_events()
    while #events > 0 and events[1][1] <= now do
        local e = table.remove(events, 1)
        local k = KEYS[e[2]]
        if k then
            local bit = 1 << k[2]
            if e[3] then matrix[k[1]] = matrix[k[1]] | bit else matrix[k[1]] = matrix[k[1]] & ~bit & 0xff end
        else
            local dir = e[2]:match("^joy_(%a+)$")
            if dir and JOY[dir] then
                if e[3] then joy = joy & ~JOY[dir] & 0xff else joy = joy | JOY[dir] end
            end
        end
    end
end

-- The screen: planes as 40 or 80 bytes a pixel row of 8 pixels a byte (bit 7
-- leftmost), the palette registers choosing each pen's colour (all zero: pen n
-- the colour n)
local function colour(v)
    local c = v
    if pal[1] | pal[2] | pal[3] ~= 0 then
        local bit = 1 << v
        c = ((pal[1] & bit) ~= 0 and 1 or 0) | ((pal[2] & bit) ~= 0 and 2 or 0) | ((pal[3] & bit) ~= 0 and 4 or 0)
    end
    return ((c & 2) ~= 0) and 255 or 0, ((c & 4) ~= 0) and 255 or 0, ((c & 1) ~= 0) and 255 or 0
end
function Spc1500.export_ppm(name)
    local stride = crtc[1] > 0 and crtc[1] or 40
    local lines = (crtc[6] > 0 and crtc[6] or 25) * (crtc[9] + 1)
    local f = assert(io.open(name .. ".ppm", "wb"))
    f:write(string.format("P6\n%d %d\n255\n", stride * 8, lines))
    for y = 0, lines - 1 do
        local row = {}
        for x = 0, stride - 1 do
            local a = (y & 7) * 0x800 + (y >> 3) * stride + x + 1
            local b, r, g = vram[a], vram[a + 0x4000], vram[a + 0x8000]
            for bit = 7, 0, -1 do
                local v = ((b >> bit) & 1) | (((r >> bit) & 1) << 1) | (((g >> bit) & 1) << 2)
                row[#row + 1] = string.char(colour(v))
            end
        end
        f:write(table.concat(row))
    end
    f:close()
end

local snaps, snap_next, snap_n = {}, 1, 0
for c in (os.getenv("SPC1500_SNAP") or ""):gmatch("%d+") do snaps[#snaps + 1] = tonumber(c) end
local function tick(cycles)
    now = cycles
    if snap_next <= #snaps and cycles >= snaps[snap_next] then
        snap_n = snap_n + 1
        snap_next = snap_next + 1
        Spc1500.export_ppm(string.format("%s/spc1500-snap-%d", OUTDIR, snap_n))
        if os.getenv("SPC1500_PLANES") then
            local f = assert(io.open(string.format("%s/spc1500-snap-%d.planes", OUTDIR, snap_n), "wb"))
            for i = 1, 0xC000 do f:write(string.char(vram[i])) end
            f:close()
            f = assert(io.open(string.format("%s/spc1500-snap-%d.regs", OUTDIR, snap_n), "w"))
            local t = {}
            for i = 0, 13 do t[#t + 1] = string.format("%02x", crtc[i]) end
            f:write(string.format("palette=%02x,%02x,%02x priority=%02x crtc=%s portc=%02x\n", pal[1], pal[2], pal[3], prio, table.concat(t, ","), portc))
            f:close()
        end
    end
end


-- The cassette.  The deck: the relay (motor) flips on each falling edge of the
-- AY's register 15 bit 7; port B bit 0 reads 1 unless the motor is on and the
-- deck is playing or recording;
-- bit 1 is the tape's level while playing.  Position is counted in T-states
-- while the motor is on: a .tap bit is 8 or 18 samples of 4,000,000 / 17,000
-- T-states.
local SAMPLE = 4000000 / 17000
local tape_bits, tape_end = {}, 0
local playing = false
do
    local path = os.getenv("SPC1500_TAPE")
    if path then
        local f = assert(io.open(path, "rb"))
        local d = f:read("a")
        f:close()
        for i = 1, #d do tape_bits[i] = d:byte(i) == 0x31 and 1 or 0 end
        playing = true
    end
end
local tape_index, tape_start_sample = 1, 0         -- the bit the (monotonic) position is in, and the sample it starts at
local motor, motor_since, tape_base = false, 0, 0
local out_path = os.getenv("SPC1500_TAPE_OUT")
local recording = out_path ~= nil
local out_file = recording and assert(io.open(out_path, "wb"))
local out_bits = {}
Spc1500.out_bits = out_bits
local pc0 = 0
local high_at = nil
local flush_out
flush_out = function()                          -- the motor stops: the bit whose high level is under way is the last
    if recording and high_at then
        local b = (now - high_at) > 1200 and 1 or 0
        out_bits[#out_bits + 1] = b
        out_file:write(b == 1 and "1" or "0")
        out_file:flush()
        high_at = nil
    end
end
local function tape_pos() return tape_base + (motor and (now - motor_since) or 0) end
local function tape_level()
    if not (playing and motor) then return 0 end
    local s = math.floor(tape_pos() / SAMPLE)
    while tape_bits[tape_index] do
        local n = tape_bits[tape_index] == 1 and 18 or 8
        if s < tape_start_sample + n then
            return (s - tape_start_sample) >= n // 2 and 1 or 0
        end
        tape_start_sample = tape_start_sample + n
        tape_index = tape_index + 1
    end
    return 0
end
local function set_motor(on)
    if on == motor then return end
    if motor then
        tape_base = tape_pos()
        flush_out()
    else
        motor_since = now
    end
    motor = on
    plog(on and "motor on" or "motor off")
end
function Spc1500.motor() return motor end
-- the cassette output: the level is low while port C bit 0 is 1; a bit ends
-- when the output goes low again
local function tape_out(bit0)
    if not (recording and motor) then pc0 = bit0; high_at = nil; return end
    if bit0 == 1 and pc0 == 0 and high_at then                       -- low again: the bit is over
        local b = (now - high_at) > 1200 and 1 or 0
        out_bits[#out_bits + 1] = b
        out_file:write(b == 1 and "1" or "0")
        out_file:flush()
        high_at = nil
    elseif bit0 == 0 and pc0 == 1 then high_at = now end             -- high: the bit's second half
    pc0 = bit0
end

function Spc1500.now() return now end
function Spc1500.ram(a) return ram[(a & 0xffff) + 1] end
function Spc1500.plane(n) local t = {} for i = 1, 0x4000 do t[i] = vram[n * 0x4000 + i] end return t end
function Spc1500.rom_selected() return rom_on end
Spc1500.prio = function() return prio end
Spc1500.portc = function() return portc end

function memory_read(addr, _type, cycles)
    tick(cycles)
    addr = addr & 0xffff
    if addr < 0x8000 and rom_on then return rom[addr + 1] end
    return ram[addr + 1]
end

function memory_write(addr, value, _type, cycles)
    tick(cycles)
    ram[(addr & 0xffff) + 1] = value
    return 0
end

local function set_portc(v)
    local b5 = (v >> 5) & 1
    double_mode = (p5 == 0 and b5 == 1)                 -- (MAME: double access starts when bit 5 is set from 0)
    p5 = b5
    portc = v
    tape_out(v & 1)
    plog(string.format("portc $%02x", v))
end

function io_in(addr, st)
    tick(st or now)
    double_mode = false                                  -- (any read ends it)
    addr = addr & 0xffff
    local hi = addr >> 8
    if addr >= 0x4000 then return vram[addr - 0x4000 + 1] end
    if addr >= 0x2000 then return text[addr - 0x2000 + 1] end
    if hi == 0x19 then
        apply_events()
        local row = addr & 0xf
        if row <= 9 then return matrix[row] end
        return 0xff
    elseif hi == 0x1a then
        local p = addr & 3
        if p == 1 then                                   -- port B: bit 7 the vertical blank (low for the last eighth of a frame), bit 0 the tape stopped, bit 3 the printer not busy
            local running = motor and (playing or recording)
            return ((now % FRAME) < FRAME * 7 // 8 and 0x80 or 0) | (running and 0 or 0x01) | (tape_level() << 1) | 0x08
        end
        return 0
    elseif hi == 0x1b then
        if ay_index == 14 then apply_events(); return joy end
        return ay[ay_index] or 0
    elseif hi == 0x18 then
        if addr & 1 == 1 then return crtc[crtc_index] end
        return 0
    end
    return nil
end

function io_out(addr, value, st)
    tick(st or now)
    addr = addr & 0xffff
    local v = value & 0xff
    local hi = addr >> 8
    if double_mode then
        if addr < 0x4000 then
            vram[addr + 1] = v; vram[addr + 0x4001] = v; vram[addr + 0x8001] = v
            return 0
        end
    end
    if addr >= 0x4000 then vram[addr - 0x4000 + 1] = v; return 0 end
    if addr >= 0x2000 then text[addr - 0x2000 + 1] = v; return 0 end
    if hi >= 0x10 and hi <= 0x12 then pal[hi - 0x10 + 1] = v; return 0
    elseif hi == 0x13 then prio = v; return 0
    elseif hi == 0x18 then
        if addr & 1 == 0 then crtc_index = v & 0x1f else crtc[crtc_index] = v end
        return 0
    elseif hi == 0x1a then
        local p = addr & 3
        if p == 2 then set_portc(v)
        elseif p == 3 then
            if v & 0x80 == 0 then                         -- bit set/reset of port C
                local bit = (v >> 1) & 7
                local n = portc & ~(1 << bit)
                if v & 1 == 1 then n = n | (1 << bit) end
                set_portc(n)
            end
        end
        return 0
    elseif hi == 0x1b then
        if ay_index == 15 and (ay[7] & 0x80) == 0 then return 0 end      -- (port B an input: ignored, as MAME's AY has it)
        if ay_index == 15 and (ay[15] & 0x80) ~= 0 and (v & 0x80) == 0 then set_motor(not motor) end
        ay[ay_index] = v
        aylog[#aylog + 1] = { ay_index, v }
        plog(string.format("ay r%d = $%02x", ay_index, v))
        return 0
    elseif hi == 0x1c then ay_index = v & 0xf; return 0
    elseif hi == 0x1d then rom_on = true; return 0
    elseif hi == 0x1e then rom_on = false; return 0
    end
    return -1
end

function memory_mmu_text() return "" end
function memory_has_banks() return false end
function memory_bank_store(_bank, _offset, _value) return -1 end
function memory_banked_pc(_pc) return nil end
function memory_banked_caller(_saved, _ret) return nil end
function memory_reset_paging() rom_on = os.getenv("SPC1500_IPL") == "1" end
