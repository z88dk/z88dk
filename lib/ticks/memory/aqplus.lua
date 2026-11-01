-- Aquarius+ Lua-owned 64 KB memory model. Each 16 KB segment is independently banked.

local banks = { 0, 1, tonumber(os.getenv("AQ_BANK2") or "19") & 0xff, tonumber(os.getenv("AQ_BANK3") or "20") & 0xff }
local initial_banks = { table.unpack(banks) }
local vctrl = 0
local pages = {}
local text = {}
for i = 1, 0x1000 do text[i] = 0 end

local function get_page(n)
    n = n & 0x3f
    local page = pages[n]
    if page == nil then
        page = {}
        for i = 1, 0x4000 do page[i] = 0 end
        pages[n] = page
    end
    return page
end

local function bank_index(addr) return (addr >> 14) + 1 end
local function mapped_page(addr) return banks[bank_index(addr)] & 0x3f end

local function text_offset(addr)
    if banks[4] & 0x40 ~= 0 and addr >= 0xf000 and addr < 0xf800 then
        return addr - 0xf000 + 1
    end
end

function memory_read(addr, _type, _cycles)
    if addr > 0xffff then
        local bank, off = addr >> 16, addr & 0xffff
        return off < 0x4000 and get_page(bank)[off + 1] or 0
    end
    local off = text_offset(addr)
    if off ~= nil then return text[off] or 0 end
    return get_page(mapped_page(addr))[(addr & 0x3fff) + 1]
end

function memory_write(addr, value, _type, _cycles)
    if addr > 0xffff then
        local bank, off = addr >> 16, addr & 0xffff
        if off < 0x4000 then get_page(bank)[off + 1] = value end
        return 0
    end
    local off = text_offset(addr)
    if off ~= nil then text[off] = value; return 0 end
    get_page(mapped_page(addr))[(addr & 0x3fff) + 1] = value
    return 0
end

local function export(path, data)
    local f = assert(io.open(path, "wb"))
    local chunk = {}
    for i, b in ipairs(data) do
        chunk[#chunk + 1] = string.char(b)
        if #chunk == 1024 then f:write(table.concat(chunk)); chunk = {} end
    end
    if #chunk > 0 then f:write(table.concat(chunk)) end
    f:close()
end

function io_in(addr)
    local port = addr & 0xff
    if port >= 0xf0 and port <= 0xf2 then return banks[port - 0xef] end
    return nil
end

function io_out(addr, value)
    local port = addr & 0xff
    value = value & 0xff
    if port >= 0xf0 and port <= 0xf3 then banks[port - 0xef] = value; return 0 end
    if port == 0xe0 then vctrl = value; return 0 end
    if port == 0xee and (value == 1 or value == 2) then
        export("aq-page20.bin", get_page(20))
        export("aq-page21.bin", get_page(21))
        export("aq-text.bin", text)
        local f = assert(io.open("aq-state.txt", "w"))
        f:write(string.format("bank0=%d\nbank1=%d\nbank2=%d\nbank3=%d\nvctrl=%d\n", banks[1], banks[2], banks[3], banks[4], vctrl))
        f:close()
        return 0
    end
    return -1
end

function memory_mmu_text()
    return string.format("Aquarius+ pages: 0=$%02X 1=$%02X 2=$%02X 3=$%02X", banks[1], banks[2], banks[3], banks[4])
end

function memory_has_banks() return true end
function memory_bank_store(bank, offset, value)
    if bank < 0 or bank >= 64 or offset < 0 or offset >= 0x4000 then return -1 end
    get_page(bank)[offset + 1] = value; return 0
end
function memory_banked_pc(pc) return (mapped_page(pc) << 16) | pc end
function memory_banked_caller(_saved, ret) return ret end
function memory_reset_paging()
    for i=1,4 do banks[i] = initial_banks[i] end
    vctrl = 0
end
