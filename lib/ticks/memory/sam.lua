-- SAM Coupé 16 KB page model for z88dk-ticks.
-- LMPR ($FA) maps a page pair at $0000-$7FFF; HMPR ($FB) maps a pair at $8000-$FFFF.
-- ROM images are read from rom0.bin and rom1.bin in the run directory (missing bytes read as zero).

local keyboard = require("keyboard_matrix").new(9, 5)

local page_count = tonumber(os.getenv("SAM_RAM_PAGES") or "16")
assert(page_count == 16 or page_count == 32, "SAM_RAM_PAGES must be 16 or 32")
local page_mask = page_count - 1
local initial_hmpr = tonumber(os.getenv("SAM_HMPR") or "0") & 0xff
local initial_lmpr = tonumber(os.getenv("SAM_LMPR") or "0x20") & 0xff
local hmpr, lmpr = initial_hmpr, initial_lmpr
local pages = {}

local function load_rom(path)
    local rom = {}
    for i = 1, 0x4000 do rom[i] = 0 end
    local f = io.open(path, "rb")
    if f ~= nil then
        local bytes = f:read(0x4000)
        f:close()
        if bytes then
            for i = 1, #bytes do rom[i] = string.byte(bytes, i) end
        end
    end
    return rom
end

local rom0, rom1 = load_rom("rom0.bin"), load_rom("rom1.bin")

local function bank_for(addr)
    local page
    if addr < 0x8000 then
        page = lmpr & 0x1f
        if addr >= 0x4000 then page = page + 1 end
    else
        page = hmpr & 0x1f
        if addr >= 0xc000 then page = page + 1 end
    end
    return page & page_mask
end

local function page_for_write(n)
    local data = pages[n]
    if data == nil then
        data = {}
        for i = 1, 0x4000 do data[i] = 0 end
        pages[n] = data
    end
    return data
end

function memory_read(addr, _type, _cycles)
    if addr > 0xffff then
        local bank, off = addr >> 16, addr & 0xffff
        local data = pages[bank]
        return off < 0x4000 and data and data[off + 1] or 0
    end
    if addr < 0x4000 and lmpr & 0x20 == 0 then return rom0[addr + 1] end
    if addr >= 0xc000 and lmpr & 0x40 ~= 0 then return rom1[(addr & 0x3fff) + 1] end
    local data = pages[bank_for(addr)]
    return data and data[(addr & 0x3fff) + 1] or 0
end

function memory_write(addr, value, _type, _cycles)
    if addr > 0xffff then
        local bank, off = addr >> 16, addr & 0xffff
        if off < 0x4000 then page_for_write(bank)[off + 1] = value end
        return 0
    end
    if addr < 0x4000 then
        if lmpr & 0x20 == 0 or lmpr & 0x80 ~= 0 then return 0 end
    elseif addr >= 0xc000 and lmpr & 0x40 ~= 0 then
        return 0
    end
    page_for_write(bank_for(addr))[(addr & 0x3fff) + 1] = value
    return 0
end

function io_in(addr)
    local port = addr & 0xff
    if port == 0xfa then return lmpr end
    if port == 0xfb then return hmpr end
    if port == 0xfe then
        local rows = (addr >> 8) & 0xff
        local value = rows == 0xff and keyboard:read(8) or keyboard:read_selected(rows)
        return 0xe0 | value
    end
    return nil
end

function io_out(addr, value)
    addr, value = addr & 0xff, value & 0xff
    if addr == 0xfa then
        lmpr = value
        return 0
    end
    if addr == 0xfb then
        hmpr = value
        return 0
    end
    -- Test-only marker: dump physical RAM without reserving a SAM hardware port.
    if addr == 0xee and value == 0xa5 then
        local f = assert(io.open("sam-ram.bin", "wb"))
        local chunk = {}
        for n = 0, page_count - 1 do
            local data = pages[n]
            for i = 1, 0x4000 do
                chunk[#chunk + 1] = string.char(data and data[i] or 0)
                if #chunk == 1024 then f:write(table.concat(chunk)); chunk = {} end
            end
        end
        if #chunk > 0 then f:write(table.concat(chunk)) end
        f:close()
        local state = assert(io.open("sam-state.txt", "w"))
        state:write(string.format("hmpr=%d\nlmpr=%d\npages=%d\n", hmpr, lmpr, page_count))
        state:close()
        return 0
    end
    return -1
end

function memory_mmu_text()
    return string.format("SAM LMPR=$%02X HMPR=$%02X RAM pages=%d", lmpr, hmpr, page_count)
end

function memory_has_banks() return true end
function memory_bank_store(bank, offset, value)
    if bank < 0 or bank >= page_count or offset < 0 or offset >= 0x4000 then return -1 end
    page_for_write(bank)[offset + 1] = value; return 0
end
function memory_banked_pc(pc)
    if (pc < 0x4000 and lmpr & 0x20 == 0) or (pc >= 0xc000 and lmpr & 0x40 ~= 0) then return nil end
    return (bank_for(pc) << 16) | pc
end
function memory_banked_caller(_saved, ret) return ret end
function memory_reset_paging() hmpr, lmpr = initial_hmpr, initial_lmpr end
