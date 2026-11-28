-- NEC PC-8001 / PC-8001mkII model for z88dk-ticks.
--
-- Memory is the flat 64 KB of ticks. There is no ROM: a program is loaded and
-- started (-l 8000 -pc 8000) and the N-BASIC routines are not available.
-- The model handles what the machine has around the memory:
--
--   * the mkII's three GVRAM planes (blue, red, green: $5C = plane 0, $5D = plane 1,
--     $5E = plane 2, $5F = main memory), paged
--     into $8000 - $BFFF, 80 bytes a pixel row and 200 rows. Port $31 has the
--     graphics on (bit 3), the 320x200 mode (bit 4), the monochrome mode (bit 2)
--     and the colour (bits 5 - 7: blue, red, green). Port $30 has the 80 column
--     bit (bit 0).
--   * the keyboard matrix: ten rows read at ports $00 - $09, a key down a 0 bit
--   * port $40 bit 5, the vertical retrace, which is high for the last eighth
--     of each 60 Hz frame
--   * the text VRAM at $F300 (25 rows of 80 characters and 20 attribute pairs),
--     which is mirrored so that it can be read back: the text is ASCII and a
--     semigraphic cell is drawn as 2x4 blocks
--
-- Environment:
--   PC8001_KEYS      "cycles:key:down,...": key events (down 1 or 0). The keys
--                    are a - z, 0 - 9, kp0 - kp9 (the keypad), kp* kp+ kp= kp,
--                    kp. return, @ [ \ ] ^ - : ; / _ comma period, home up right
--                    del grph kana shift ctrl, stop f1 - f5 space escape
--   PC8001_SNAP      "cycles,...": write pc8001-snap-<n>.ppm (the graphics
--                    screen and the semigraphics) and pc8001-snap-<n>.txt (the
--                    text screen) at the first access after each cycle count
--   PC8001_PLANES    also write pc8001-snap-<n>.planes (the three planes,
--                    16000 bytes each)
--   PC8001_PORTLOG   write ports.txt: every write to port $40 (the beeper is bit 5),
--                    with its time in T-states
--   PC8001_OUTDIR    where the files go (default .)
--
-- A test can use the global table Pc8001: planes, p30(), p31(), plane(),
-- screen_text(), export_ppm(name), export_text(name).

local Pc8001 = {}
_G.Pc8001 = Pc8001

local keyboard = require("keyboard_matrix").new(10, 8)

local FRAME = 66667                              -- 4 MHz / 60
local OUTDIR = os.getenv("PC8001_OUTDIR") or "."
local now = 0
local portlog = os.getenv("PC8001_PORTLOG") and assert(io.open(OUTDIR .. "/ports.txt", "w"))

local TVRAM, TROWS, TSTRIDE = 0xf300, 25, 120
local tvram = {}
for i = 1, TROWS * TSTRIDE do tvram[i] = 0 end

local planes = {}
for p = 1, 3 do
    planes[p] = {}
    for i = 1, 0x4000 do planes[p][i] = 0 end
end
local plane = 0                                  -- 0 = main memory
local p30, p31 = 0, 0
Pc8001.planes = planes
function Pc8001.plane() return plane end
function Pc8001.p30() return p30 end
function Pc8001.p31() return p31 end

-- The keyboard matrix: row n is read at port n
local ROWS = {
    [0] = { "kp0", "kp1", "kp2", "kp3", "kp4", "kp5", "kp6", "kp7" },
    { "kp8", "kp9", "kp*", "kp+", "kp=", "kp,", "kp.", "return" },
    { "@", "a", "b", "c", "d", "e", "f", "g" },
    { "h", "i", "j", "k", "l", "m", "n", "o" },
    { "p", "q", "r", "s", "t", "u", "v", "w" },
    { "x", "y", "z", "[", "\\", "]", "^", "-" },
    { "0", "1", "2", "3", "4", "5", "6", "7" },
    { "8", "9", ":", ";", "comma", "period", "/", "_" },
    { "home", "up", "right", "del", "grph", "kana", "shift", "ctrl" },
    { "stop", "f1", "f2", "f3", "f4", "f5", "space", "escape" },
}
local KEYS = {}
for row = 0, 9 do
    for bit = 1, 8 do KEYS[ROWS[row][bit]] = { row, bit - 1 } end
end

local events = {}
for cycles, name, down in (os.getenv("PC8001_KEYS") or ""):gmatch("(%d+):([^:,]+):(%d)") do
    events[#events + 1] = { tonumber(cycles), name, down == "1" }
end
table.sort(events, function(a, b) return a[1] < b[1] end)
local function apply_events()
    while #events > 0 and events[1][1] <= now do
        local e = table.remove(events, 1)
        local k = KEYS[e[2]]
        if k then keyboard:set_key(k[1], k[2], e[3]) end
    end
end

-- The text screen: the attribute pairs of a row (a start column and an
-- attribute, the attribute holding from there to the next start, $80 ends the
-- list) expanded to one attribute a column
-- When port $30 bit 1 is 0 the machine is in colour mode: a pair with bit 3 set
-- is a colour (bits 7 - 5 are green, red and blue, bit 4 is semigraphics) and
-- one with bit 3 clear is a decoration.
-- Returns the semigraphics flag and the colour (0 - 7, 7 is white) of each column
local function row_attrs(row)
    local base = row * TSTRIDE + 80
    local semi, colour, deco = {}, {}, {}
    local colour_mode = (p30 & 2) == 0
    local cur_semi, cur_col, cur_deco = false, 7, 0
    local pairs_ = {}
    for i = 0, 19 do
        pairs_[#pairs_ + 1] = { tvram[base + i * 2 + 1], tvram[base + i * 2 + 2] }
    end
    local nextp = 1
    for c = 0, 79 do
        while pairs_[nextp] and pairs_[nextp][1] < 80 and pairs_[nextp][1] <= c do
            local v = pairs_[nextp][2]
            if not colour_mode then
                cur_semi = (v & 0x80) ~= 0
            elseif (v & 8) ~= 0 then
                cur_col = (v >> 5) & 7
                cur_semi = (v & 0x10) ~= 0
            else
                cur_deco = v
            end
            nextp = nextp + 1
        end
        semi[c], colour[c], deco[c] = cur_semi, cur_col, cur_deco
    end
    return semi, colour, deco
end

function Pc8001.screen_text()
    local lines = {}
    local step = (p30 & 1) == 0 and 2 or 1       -- 40 columns use the even cells
    for r = 0, TROWS - 1 do
        local semi, line = row_attrs(r), {}
        for c = 0, 79, step do
            local ch = tvram[r * TSTRIDE + c + 1]
            if semi[c] then line[#line + 1] = ch ~= 0 and "#" or " "
            elseif ch >= 32 and ch < 127 then line[#line + 1] = string.char(ch)
            else line[#line + 1] = " " end
        end
        lines[#lines + 1] = (table.concat(line):gsub("%s+$", ""))
    end
    return lines
end

function Pc8001.export_text(name)
    local f = assert(io.open(name .. ".txt", "w"))
    for _, l in ipairs(Pc8001.screen_text()) do f:write(l, "\n") end
    f:close()
end

-- The graphics screen. The planes are ORed together. The mono mode has the
-- colour of port $31 bits 5 - 7. The 320x200 mode has two bits a pixel: 0 is
-- black (blue when port $31 bit 2 is set), 1 is red, 2 is green (both with the
-- blue as well when bit 2 is set) and 3 is the colour of bits 5 - 7.
local function pen(v)
    local blue = (p31 & 4) ~= 0 and 255 or 0
    if v == 3 then
        return ((p31 & 0x40) ~= 0) and 255 or 0, ((p31 & 0x80) ~= 0) and 255 or 0, ((p31 & 0x20) ~= 0) and 255 or 0
    end
    return (v == 1) and 255 or 0, (v == 2) and 255 or 0, blue
end

function Pc8001.export_ppm(name)
    local W, H = 640, 200
    local img = {}
    for y = 0, H - 1 do
        local row = {}
        for x = 0, W - 1 do row[x] = { 0, 0, 0 } end
        img[y] = row
    end
    if (p31 & 8) ~= 0 then
        local mono, wide = (p31 & 4) ~= 0, (p31 & 0x10) ~= 0
        for y = 0, H - 1 do
            for b = 0, 79 do
                local i = y * 80 + b + 1
                local v = planes[1][i] | planes[2][i] | planes[3][i]
                if wide then
                    for k = 0, 3 do
                        local r, g, bl = pen((v >> (6 - 2 * k)) & 3)
                        local px = {r, g, bl}
                        img[y][b * 8 + k * 2], img[y][b * 8 + k * 2 + 1] = px, px
                    end
                else
                    local r, g, bl = 0, 0, 0
                    if mono then
                        r = ((p31 & 0x40) ~= 0) and 255 or 0
                        g = ((p31 & 0x80) ~= 0) and 255 or 0
                        bl = ((p31 & 0x20) ~= 0) and 255 or 0
                    end
                    for k = 0, 7 do
                        if (v >> (7 - k)) & 1 == 1 then img[y][b * 8 + k] = { r, g, bl } end
                    end
                end
            end
        end
    end
    -- the semigraphic cells: a 2x4 block of pixels, the left half in bits 0 - 3
    local narrow = (p30 & 1) == 0
    for r = 0, TROWS - 1 do
        local semi, colour = row_attrs(r)
        for c = 0, 79 do
            if semi[c] and (not narrow or c % 2 == 0) then
                local ch = tvram[r * TSTRIDE + c + 1]
                local w = narrow and 16 or 8
                local x0 = (narrow and c // 2 * 16 or c * 8)
                for py = 0, 7 do
                    for px = 0, w - 1 do
                        local half = (px * 2 // w)                       -- 0 left, 1 right
                        if (ch >> (half * 4 + py // 2)) & 1 == 1 then img[r * 8 + py][x0 + px] = { (colour[c] & 2) ~= 0 and 255 or 0, (colour[c] & 4) ~= 0 and 255 or 0, (colour[c] & 1) ~= 0 and 255 or 0 } end
                    end
                end
            end
        end
    end
    local f = assert(io.open(name .. ".ppm", "wb"))
    f:write(string.format("P6\n%d %d\n255\n", W, H))
    for y = 0, H - 1 do
        local row = {}
        for x = 0, W - 1 do row[#row + 1] = string.char(img[y][x][1], img[y][x][2], img[y][x][3]) end
        f:write(table.concat(row))
    end
    f:close()
end

local snaps, snap_next, snap_n = {}, 1, 0
for c in (os.getenv("PC8001_SNAP") or ""):gmatch("%d+") do snaps[#snaps + 1] = tonumber(c) end
local function tick(cycles)
    now = cycles
    if #events > 0 then apply_events() end
    if snap_next <= #snaps and cycles >= snaps[snap_next] then
        snap_n = snap_n + 1
        snap_next = snap_next + 1
        local base = string.format("%s/pc8001-snap-%d", OUTDIR, snap_n)
        Pc8001.export_ppm(base)
        Pc8001.export_text(base)
        if os.getenv("PC8001_PLANES") then
            local f = assert(io.open(base .. ".planes", "wb"))
            for p = 1, 3 do
                local chunk = {}
                for i = 1, 16000 do chunk[i] = string.char(planes[p][i]) end
                f:write(table.concat(chunk))
            end
            f:close()
        end
    end
end

function memory_read(addr, _type, cycles)
    if cycles then tick(cycles) end
    if plane == 0 or addr < 0x8000 or addr > 0xbfff then return nil end
    return planes[plane][addr - 0x8000 + 1]
end

function memory_write(addr, value, _type, cycles)
    if cycles then tick(cycles) end
    if addr >= TVRAM and addr < TVRAM + TROWS * TSTRIDE then
        tvram[addr - TVRAM + 1] = value            -- (and the flat memory has it as well)
        return -1
    end
    if plane == 0 or addr < 0x8000 or addr > 0xbfff then return -1 end
    planes[plane][addr - 0x8000 + 1] = value
    return 0
end

function io_in(addr, st)
    if st then tick(st) end
    addr = addr & 0xff
    if addr <= 9 then return keyboard:read(addr) end
    if addr == 0x40 then
        return (now % FRAME) >= FRAME - FRAME // 8 and 0x20 or 0
    end
    return nil
end

function io_out(addr, value, st)
    if st then tick(st) end
    addr, value = addr & 0xff, value & 0xff
    if addr >= 0x5c and addr <= 0x5f then plane = addr == 0x5f and 0 or addr - 0x5b; return 0
    elseif addr == 0x30 then p30 = value; return 0
    elseif addr == 0x31 then p31 = value; return 0
    elseif addr == 0x40 then
        if portlog then portlog:write(string.format("%d %02x\n", now, value)); portlog:flush() end
        return 0
    elseif addr == 0x50 or addr == 0x51 or (addr >= 0x60 and addr <= 0x68) then return 0
    end
    return -1
end

function memory_mmu_text()
    return string.format("PC-8001 plane=%d p30=$%02X p31=$%02X", plane, p30, p31)
end

function memory_has_banks() return false end
function memory_bank_store(_bank, _offset, _value) return -1 end
function memory_banked_pc(_pc) return nil end
function memory_banked_caller(_saved, _ret) return nil end
function memory_reset_paging() plane, p30, p31 = 0, 0, 0 end
