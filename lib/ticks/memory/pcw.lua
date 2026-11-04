-- Amstrad PCW (8256/8512/9512/10, CP/M Plus) Lua-owned 64 KB memory model for z88dk-ticks: z88dk-ticks -b lua -lua pcw.lua ...
--
-- 16 banks of 16 KB.  The four 16 KB windows of the Z80's space are set by ports $F0-$F3 (the low four bits of the value are the bank: $80 + n as CP/M Plus writes it),
-- and start as CP/M Plus's TPA: banks 4, 5 and 6 at $0000-$BFFF and the common bank 7 at $C000.  Banks 1 and 2 are the screen's: paged in over $4000 and $8000 (as
-- z88dk's pcw graphics library does: $81 and $82 in, $85 and $86 out) they hold the 90 byte columns of the text rows and the roller RAM at $B600.  The roller RAM
-- (256 words, one for each line of the screen) is filled in as CP/M Plus leaves it: line y is at PCW_SCREEN (default $5930, CP/M Plus's) + (y >> 3) * 720 + (y & 7).
--
-- Port $EE (not the machine's): out ($EE),1 or 2 writes pcw-screen.bin (banks 1 and 2: the CPU's $4000-$BFFF when they are paged in) and pcw-state.txt (the banks).
--
-- A test can hook in without a second layer of callbacks: the global table PCW has
--   PCW.io_in(port, high)     called for a port the model does not know: its value, or nil
--   PCW.io_out(port, value)   the same for a write: 0 if it took it
--   PCW.protect_base          true to drop writes to $0000-$0007 while the TPA is paged in (z88dk-ticks writes its CP/M trap at address 5 of a .com)
--   PCW.now()                 the cycles run so far, as of the last memory access
--   PCW.page(n)               bank n's 16 KB as a table of bytes (1 based)
--   PCW.export_screen(name)   writes name.bin as the port $EE does

PCW = PCW or {}
local SCREEN = tonumber(os.getenv("PCW_SCREEN") or "0x5930")
local ROW_BYTES = 720

local pages = {}
local function page(n)
    n = n & 0x0f
    local p = pages[n]
    if p == nil then
        p = {}
        for i = 1, 0x4000 do p[i] = 0 end
        pages[n] = p
    end
    return p
end
PCW.page = page

local initial = { 4, 5, 6, 7 }
local banks = { table.unpack(initial) }
local map = {}                                      -- the page tables the banks select: an access does not call a function to find its page
local function remap() for i = 1, 4 do map[i] = page(banks[i]) end end
local now = 0

for y = 0, 255 do
    local a = SCREEN + (y >> 3) * ROW_BYTES + (y & 7)
    local w = ((a >> 1) & 0x7ff8) | (a & 7)
    page(2)[0x3600 + 2 * y + 1] = w & 0xff
    page(2)[0x3600 + 2 * y + 2] = w >> 8
end
remap()

function PCW.now() return now end

function memory_read(addr, _type, cycles)
    now = cycles
    if addr > 0xffff then
        local bank, off = addr >> 16, addr & 0xffff
        return off < 0x4000 and page(bank)[off + 1] or 0
    end
    return map[(addr >> 14) + 1][(addr & 0x3fff) + 1]
end

function memory_write(addr, value, _type, cycles)
    now = cycles
    if addr > 0xffff then
        local bank, off = addr >> 16, addr & 0xffff
        if off < 0x4000 then page(bank)[off + 1] = value end
        return 0
    end
    if addr < 8 and PCW.protect_base and banks[1] == 4 then return 0 end
    map[(addr >> 14) + 1][(addr & 0x3fff) + 1] = value
    return 0
end

local function export(path, data, n)
    local f = assert(io.open(path, "wb"))
    local chunk = {}
    for i = 1, n do
        chunk[#chunk + 1] = string.char(data[i])
        if #chunk == 1024 then f:write(table.concat(chunk)); chunk = {} end
    end
    if #chunk > 0 then f:write(table.concat(chunk)) end
    f:close()
end

function PCW.export_screen(name)
    local bytes = {}
    for n = 1, 2 do
        local p = page(n)
        for i = 1, 0x4000 do bytes[#bytes + 1] = p[i] end
    end
    export(name .. ".bin", bytes, #bytes)
    local f = assert(io.open("pcw-state.txt", "w"))
    f:write(string.format("bank0=%d\nbank1=%d\nbank2=%d\nbank3=%d\n", banks[1], banks[2], banks[3], banks[4]))
    f:close()
end

function io_in(addr)
    local port = addr & 0xff
    if port >= 0xf0 and port <= 0xf3 then return 0x80 | banks[port - 0xef] end
    if PCW.io_in then return PCW.io_in(port, (addr >> 8) & 0xff) end
    return nil
end

function io_out(addr, value)
    local port = addr & 0xff
    value = value & 0xff
    if port >= 0xf0 and port <= 0xf3 then
        banks[port - 0xef] = value & 0x0f
        map[port - 0xef] = page(value & 0x0f)
        return 0
    end
    if port == 0xee and (value == 1 or value == 2) then
        PCW.export_screen("pcw-screen")
        return 0
    end
    if PCW.io_out then return PCW.io_out(port, value) or -1 end
    return -1
end

function memory_mmu_text()
    return string.format("PCW banks: %d %d %d %d", banks[1], banks[2], banks[3], banks[4])
end

function memory_has_banks() return true end
function memory_bank_store(bank, offset, value)
    if bank < 0 or bank >= 16 or offset < 0 or offset >= 0x4000 then return -1 end
    page(bank)[offset + 1] = value; return 0
end
function memory_banked_pc(pc) return (banks[(pc >> 14) + 1] << 16) | pc end
function memory_banked_caller(_saved, ret) return ret end
function memory_reset_paging()
    for i = 1, 4 do banks[i] = initial[i] end
    remap()
end
