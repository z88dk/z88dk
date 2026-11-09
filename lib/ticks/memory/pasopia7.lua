-- Toshiba Pasopia 7 model for z88dk-ticks: z88dk-ticks -b lua -lua pasopia7.lua ...   (after Takeda's EmuPIA7: src/vm/pasopia7/memory.cpp, display.cpp)
--
-- Memory: 64 KB of RAM (no ROMs: the machine is in the "all RAM" state that z88dk's bootstrap leaves, port $3C bits 0-1 = 2; the ROM states read $FF and drop writes), and 64 KB of video
-- RAM in four planes of 16 KB: blue ($0000), red ($4000), green or the character codes ($8000), the attributes ($C000).  Port $3C bit 2 maps the video RAM over $8000-$BFFF (the address
-- inside a plane is the CPU's & $3FFF).  Which planes a write goes to and which a read looks at is the plane register (8255 #1 port A, $0C):
--     write: bit 4 blue, 5 red, 6 green (and the attribute, from port B, is written with it unless port C bit 4 holds it): a plane with its bit 0, 1 or 2 set gets the data, else $FF
--     read:  the planes whose bits 4, 5 and 6 and 0, 1, 2 are both set are ANDed ($FF if none)
--     with the palette select (port C bit 2 or 3) and bits 4-6 clear, a write to $8000 + n sets palette entry n (the low 4 bits); a read gives it
-- Port $08 (8255 #0 port A) is the display mode ($80 = fine graph, wide: 320 x 200); the attribute of each scan line has bit 3 set for "dot mode" (the planes are the pixels: colour index
-- blue | red << 1 | green << 2, the palette gives the colour: bit 0 blue, bit 1 red, bit 2 green).
--
-- Screen: export_ppm(name) writes name.ppm, 320 x 200: the cells of the fine graph mode, a cell 8 contiguous bytes in each plane (the CRTC start address is taken as 0), the lines
-- whose attribute is not dot mode black (the character layer is not drawn).  PASOPIA_SNAP="cycles,cycles,..." writes pasopia-snap-<n>.ppm at the first memory access after each.
-- Env: PASOPIA_OUTDIR (default the current directory).  PASOPIA_TRACE="addr,from,to" (hex address, cycles): the cycle count of every fetch of that address between the counts, to pasopia-trace.txt
-- (the passes of a game loop: the address of plat_idle).  PASOPIA_PROF="from,to": the cycles each instruction address (the one fetched) takes, between those cycle counts, are written to
-- pasopia-prof.txt ("address cycles", hex) at the first access after `to`: for a profile by function from the map file.
--
-- Port $09 (8255 #0 port B) bit 5 is the vertical sync: high for the first 3000 cycles of every 66624 (60 Hz at 3.9936 MHz).  The keyboard is the matrix of Takeda's keyboard.cpp: write the
-- select byte to $30 (bits 4-6 the chunks, bits 0-3 the rows within), read $31: a pressed key a 0 bit.  PASOPIA_KEYS="cycles:key:1,cycles:key:0": at that many cycles the named key
-- (Pasopia.key's names) goes down (1) or up (0), applied when the keyboard is next read.  Pasopia.key(name, down); Pasopia.set_key(select_byte, bit, down).
-- The floppy disk: z88dk's lib/ticks/upd765.lua behind the ports $E4 (main status), $E5 (data), $E2 (terminal count on), $E0 (off) and $E6 (bit 6 the motor); one side, 40
-- cylinders of 16 sectors of 256 bytes.  PASOPIA_DISC is an image: a .dsk (the extended CPC format of appmake +pasopia7) or a .d88; without one the sectors are a pattern.  Port $F0
-- written with 1 writes disk_out.txt (the sectors written: "cylinder head id hex"), fdc_log.txt (the commands) and fdc_errors.txt (what the model did not like) to PASOPIA_OUTDIR.
-- The Z80 CTC (ports $28-$2B): channel 0 as a timer with the prescaler 256 and a time constant of 256, channel 1 as a counter of its output, as plat_time.asm programs them: a read of
-- port $28 or $29 gives the channel's count, falling a step every 256 cycles (channel 0: 256 is read as 0) and, for channel 1, every 65536.  Other modes are not modelled.
-- The sound: every write to port $3A (the first SN76489) is logged with the cycle count: Pasopia.psg = { { cycles, byte }, ... }, written to psg_out.txt ("cycles byte") by port $F0 = 1.
-- The global table Pasopia: .vram(i) .ram(i) (0 based), .export_ppm(name), .pal, .io_in(port) .io_out(port, value) for ports the model does not know (a value or nil, 0 or nil).
package.path = (os.getenv("ZCCCFG") or "") .. "/../ticks/?.lua;" .. package.path
Pasopia = Pasopia or {}
local ram, vram, pal = {}, {}, {}
for i = 1, 0x10000 do ram[i] = 0; vram[i] = 0 end
for i = 0, 15 do pal[i] = i & 7 end
Pasopia.pal = pal
Pasopia.ram = function(i) return ram[i + 1] end
Pasopia.vram = function(i) return vram[i + 1] end

local mem_map, vram_sel = 2, false
local plane, attr_data, attr_latch, pal_sel, attr_wrap, pal_dis = 0, 0, 0, false, false, false
local mode = 0
local now = 0

local prof_from, prof_to = (os.getenv("PASOPIA_PROF") or ""):match("(%d+),(%d+)")
prof_from, prof_to = tonumber(prof_from), tonumber(prof_to)
local prof, prof_pc, prof_c, prof_done = {}, nil, 0, false
local tr_addr, tr_from, tr_to = (os.getenv("PASOPIA_TRACE") or ""):match("(%x+),(%d+),(%d+)")
tr_addr, tr_from, tr_to = tonumber(tr_addr or "-1", 16), tonumber(tr_from), tonumber(tr_to)
local tr_list, tr_done = {}, false
local snaps, snap_next, snap_n = {}, 1, 0
for c in (os.getenv("PASOPIA_SNAP") or ""):gmatch("(%d+)") do snaps[#snaps + 1] = tonumber(c) end

function Pasopia.export_ppm(name)
    local f = assert(io.open(name .. ".ppm", "wb"))
    f:write("P6\n320 200\n255\n")
    for y = 0, 199 do
        local row = {}
        local cy, l = y // 8, y % 8
        for cx = 0, 39 do
            local a = (cy * 40 + cx) * 8 + l + 1
            local attr = vram[0xc000 + a]
            local b, r, g = vram[a], vram[0x4000 + a], vram[0x8000 + a]
            for bit = 7, 0, -1 do
                local c = 0
                if attr & 8 ~= 0 then
                    local idx = ((b >> bit) & 1) | (((r >> bit) & 1) << 1) | (((g >> bit) & 1) << 2)
                    c = pal[idx] & 7
                end
                row[#row + 1] = string.char((c & 2 ~= 0) and 255 or 0, (c & 4 ~= 0) and 255 or 0, (c & 1 ~= 0) and 255 or 0)
            end
        end
        f:write(table.concat(row))
    end
    f:close()
end

function memory_read(addr, _type, cycles)
    now = cycles
    if tr_from and not tr_done then
        if cycles > tr_to then
            tr_done = true
            local f = assert(io.open((os.getenv("PASOPIA_OUTDIR") or ".") .. "/pasopia-trace.txt", "w"))
            for _, c in ipairs(tr_list) do f:write(c, "\n") end
            f:close()
        elseif _type == ticks.MEM_TYPE_INST and addr == tr_addr and cycles >= tr_from then
            tr_list[#tr_list + 1] = cycles
        end
    end
    if prof_from and not prof_done then
        if cycles > prof_to then
            prof_done = true
            local f = assert(io.open((os.getenv("PASOPIA_OUTDIR") or ".") .. "/pasopia-prof.txt", "w"))
            for pc, c in pairs(prof) do f:write(string.format("%04x %d\n", pc, c)) end
            f:close()
        elseif cycles >= prof_from and _type == ticks.MEM_TYPE_INST then
            if prof_pc then prof[prof_pc] = (prof[prof_pc] or 0) + (cycles - prof_c) end
            prof_pc, prof_c = addr & 0xffff, cycles
        end
    end
    if snap_next <= #snaps and cycles >= snaps[snap_next] then
        snap_n = snap_n + 1
        snap_next = snap_next + 1
        Pasopia.export_ppm(string.format("%s/pasopia-snap-%d", os.getenv("PASOPIA_OUTDIR") or ".", snap_n))
        if os.getenv("PASOPIA_VRAM") then
            local f = assert(io.open((os.getenv("PASOPIA_OUTDIR") or ".") .. "/pasopia-vram.bin", "wb"))
            for i = 1, 0x10000 do f:write(string.char(vram[i])) end
            f:close()
        end
    end
    addr = addr & 0xffff
    if vram_sel and (addr & 0xc000) == 0x8000 then
        if pal_sel and (plane & 0x70) == 0 then return pal[addr & 0x0f] end
        local l = addr & 0x3fff
        local v = 0xff
        if (plane & 0x11) == 0x11 then v = v & vram[l + 1] end
        if (plane & 0x22) == 0x22 then v = v & vram[0x4000 + l + 1] end
        if (plane & 0x44) == 0x44 then
            attr_latch = vram[0xc000 + l + 1]
            v = v & vram[0x8000 + l + 1]
        end
        return v
    end
    if mem_map & 3 ~= 2 then return 0xff end
    return ram[addr + 1]
end

function memory_write(addr, value, _type, cycles)
    now = cycles
    addr = addr & 0xffff
    if vram_sel and (addr & 0xc000) == 0x8000 then
        if pal_sel and (plane & 0x70) == 0 then pal[addr & 0x0f] = value & 0x0f; return 0 end
        local l = addr & 0x3fff
        if plane & 0x10 ~= 0 then vram[l + 1] = (plane & 1) ~= 0 and value or 0xff end
        if plane & 0x20 ~= 0 then vram[0x4000 + l + 1] = (plane & 2) ~= 0 and value or 0xff end
        if plane & 0x40 ~= 0 then
            vram[0x8000 + l + 1] = (plane & 4) ~= 0 and value or 0xff
            if not attr_wrap then attr_latch = attr_data end
            vram[0xc000 + l + 1] = attr_latch
        end
        return 0
    end
    if mem_map & 3 == 2 then ram[addr + 1] = value end
    return 0
end

-- the disk
local function edsk_to_d88(path)
    local f = assert(io.open(path, "rb"))
    local d = f:read("a")
    f:close()
    if d:sub(1, 8) ~= "EXTENDED" and d:sub(1, 8) ~= "MV - CPC" then return path end
    local ntr, nsi = d:byte(0x31), d:byte(0x32)
    local out = { string.rep("\0", 0x2b0) }
    local tracks, pos = {}, 0x100 + 1
    local offset = 0x2b0
    local tab = {}
    for t = 0, ntr * nsi - 1 do
        local size = d:byte(0x35 + t) * 256
        local nsec = d:byte(pos + 0x15)
        local blk = {}
        local data = pos + 0x100
        for i = 0, nsec - 1 do
            local h = pos + 0x18 + 8 * i
            local c, hd, r, n = d:byte(h), d:byte(h + 1), d:byte(h + 2), d:byte(h + 3)
            local len = d:byte(h + 6) + 256 * d:byte(h + 7)
            if len == 0 then len = 128 << n end
            blk[#blk + 1] = string.pack("BBBB<I2BBBc5<I2", c, hd, r, n, nsec, 0, 0, 0, string.rep("\0", 5), len) .. d:sub(data, data + len - 1)
            data = data + len
        end
        local track = table.concat(blk)
        tab[t] = offset
        offset = offset + #track
        out[#out + 1] = track
        pos = pos + size
    end
    local head = { string.rep("\0", 0x20) }
    for t = 0, 163 do head[#head + 1] = string.pack("<I4", tab[t] or 0) end
    local all = table.concat(out)
    all = table.concat(head):sub(1, 0x2b0) .. all:sub(0x2b1)
    local tmp = os.tmpname()
    local g = assert(io.open(tmp, "wb"))
    g:write(all)
    g:close()
    return tmp
end
local disc = os.getenv("PASOPIA_DISC")
if disc then disc = edsk_to_d88(disc) end
local ctc_t0, ctc_tc, ctc_wait = nil, {}, {}
local psg = {}
Pasopia.psg = psg
local fdc = require("upd765")({ image = disc, cylinders = 40, heads = 1, sectors = 16 })
Pasopia.fdc = fdc

-- the keyboard: down[select byte of a row][bit]; the names are those of the game's key codes
local KEYS = {}
do
    local rows = {
        [0x41] = { "-", "5", "6", "f", "h", "9", ":", "}" },
        [0x42] = { "q", "w", "e", "g", "j", "i", "o", "p" },
        [0x44] = { "a", "s", "d", "v", "n", "k", "l", ";" },
        [0x48] = { "z", "x", "c", "b", "m", ",", ".", "/" },
        [0x21] = { false, false, false, false, "left", "up", false, "space" },
        [0x22] = { "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8" },
        [0x24] = { "1", "0", "4", "r", "y", "=", "\\", "yen" },
        [0x28] = { "2", "3", "8", "t", "u", "7", "@", "{" },
        [0x11] = { "ctrl", "shift", "caps", false, false, "kana", false, false },
        [0x12] = { "kp0", "kp1", "kp2", "kp3", "kp4", "kp5", "kp6", "kp7" },
        [0x14] = { "kp8", "kp9", "kp-", "down", "up2", false, false, "return" },
        [0x18] = { "right", "status", "backspace", "escape", false, false, false, false },
    }
    for sel, names in pairs(rows) do
        for bit = 1, 8 do if names[bit] then KEYS[names[bit]] = { sel, bit - 1 } end end
    end
    KEYS[" "] = KEYS["space"]
end
local keydown = {}
local keysel = 0
function Pasopia.set_key(sel, bit, down)
    keydown[sel] = keydown[sel] or {}
    keydown[sel][bit] = down and true or nil
end
function Pasopia.key(name, down)
    local k = KEYS[name]
    if not k then error("Pasopia.key: no key " .. tostring(name)) end
    Pasopia.set_key(k[1], k[2], down ~= false)
end
local events, next_event = {}, 1
for cycles, name, down in (os.getenv("PASOPIA_KEYS") or ""):gmatch("(%d+):([^:,]+):(%d)") do
    events[#events + 1] = { tonumber(cycles), name, down == "1" }
end
table.sort(events, function(a, b) return a[1] < b[1] end)

function io_in(addr, st)
    now = st or now
    local p = addr & 0xff
    if p == 0x09 then return ((now % 66624) < 3000) and 0x20 or 0 end
    if p == 0x28 or p == 0x29 then
        if not ctc_t0 then return 0 end
        local k = (now - ctc_t0) // 256
        if p == 0x28 then return (256 - k % 256) % 256 end
        return (256 - (k // 256) % 256) % 256
    end
    if p == 0xe4 then return fdc.msr() end
    if p == 0xe5 then return fdc.data_read() end
    if p == 0xe6 then return 0 end
    if p == 0x31 then
        while next_event <= #events and events[next_event][1] <= now do
            Pasopia.key(events[next_event][2], events[next_event][3])
            next_event = next_event + 1
        end
        local v = 0
        for sel, bits in pairs(keydown) do
            if sel & 0x70 & keysel ~= 0 and sel & 0x0f & keysel ~= 0 then
                for bit in pairs(bits) do v = v | (1 << bit) end
            end
        end
        return (~v) & 0xff
    end
    if Pasopia.io_in then return Pasopia.io_in(p) end
    return nil
end

function io_out(addr, value, st)
    now = st or now
    local p, v = addr & 0xff, value & 0xff
    if p == 0x3c then
        mem_map = v & 7
        vram_sel = (v & 4) ~= 0
        return 0
    elseif p == 0x08 then mode = v; return 0
    elseif p == 0x0c then plane = v; return 0
    elseif p == 0x0d then attr_data = v & 0x0f; return 0
    elseif p == 0x0e then
        attr_wrap = (v & 0x10) ~= 0
        pal_sel = (v & 0x0c) ~= 0
        pal_dis = (v & 0x08) ~= 0
        return 0
    elseif p == 0x30 then keysel = v; return 0
    elseif p == 0xe5 then fdc.data_write(v); return 0
    elseif p == 0xe2 then fdc.tc(); return 0
    elseif p == 0xe0 then return 0
    elseif p == 0xe6 then fdc.motor((v & 0x40) ~= 0); return 0
    elseif p >= 0x28 and p <= 0x2b then
        local ch = p - 0x28
        if ctc_wait[ch] then
            ctc_wait[ch] = false
            if ch == 0 then ctc_t0 = now end
        elseif v & 1 ~= 0 then
            ctc_wait[ch] = (v & 4) ~= 0
        end
        return 0
    elseif p == 0x3a then psg[#psg + 1] = { now, v }; return 0
    elseif p == 0x3b then return 0
    elseif p == 0xf0 then
        if v == 1 then
            local pf = assert(io.open((os.getenv("PASOPIA_OUTDIR") or ".") .. "/psg_out.txt", "w"))
            for _, e in ipairs(psg) do pf:write(e[1], " ", e[2], "\n") end
            pf:close()
            local dir = os.getenv("PASOPIA_OUTDIR") or "."
            fdc.dump(dir)
            local e = assert(io.open(dir .. "/fdc_errors.txt", "w")); e:write(table.concat(fdc.errors, "\n"), "\n"); e:close()
        end
        return 0
    elseif p == 0x0f then
        if v & 0x80 ~= 0 then plane, attr_data, attr_wrap, pal_sel, pal_dis = 0, 0, false, false, false end
        return 0
    end
    if Pasopia.io_out then return Pasopia.io_out(p, v) or -1 end
    return -1
end

function memory_mmu_text()
    return string.format("Pasopia 7 port3c=%d vram_sel=%s plane=%02X", mem_map, tostring(vram_sel), plane)
end
