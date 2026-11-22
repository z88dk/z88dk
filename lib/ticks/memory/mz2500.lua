-- MZ-2500 8 KB windowed memory and CG RMW page model for z88dk-ticks.

local keyboard = require("keyboard_matrix").new(12, 8)
local pio_a = 0xff
local initial_windows = { 0, 1, 2, 3, 0x20, 0x22, 0x24, 0x26 }
local test_window = tonumber(os.getenv("MZ_WINDOW") or "-1")
if test_window >= 0 and test_window < 8 then initial_windows[test_window+1] = 8 end
initial_windows[3] = tonumber(os.getenv("MZ_W2") or tostring(initial_windows[3])) & 0xff
initial_windows[4] = tonumber(os.getenv("MZ_W3") or tostring(initial_windows[4])) & 0xff
local windows = { table.unpack(initial_windows) }
local pages = {}
local selected = 0
local regs, latches = {}, {0, 0, 0, 0}
local regsel = 0
local badmode, badmode_r5, badmode_addr, badmode_value = 0, 0, 0, 0
for i=1,16 do regs[i] = 0 end

local function page(n)
    n = n & 0xff
    if n == 0x38 or n == 0x39 then n = 0x26 end
    if not pages[n] then
        pages[n] = {}
        for i=1,0x2000 do pages[n][i] = 0 end
    end
    return pages[n]
end
local function mapped(addr) return windows[(addr >> 13) + 1] end
local function offset(addr) return (addr & 0x1fff) + 1 end
local function export(path, data)
    local f = assert(io.open(path, "wb")); local chunk = {}
    for i,b in ipairs(data) do
        chunk[#chunk+1] = string.char(b)
        if #chunk == 1024 then f:write(table.concat(chunk)); chunk={} end
    end
    if #chunk > 0 then f:write(table.concat(chunk)) end
    f:close()
end
local function snapshot()
    for p=0,3 do
        export(string.format("mz-plane%d.bin",p), page(0x20 + p*2))
        export(string.format("mz-plane-b%d.bin",p), page(0x21 + p*2))
    end
    local logical = {}
    for addr=0,0xffff do logical[#logical+1] = page(mapped(addr))[offset(addr)] end
    export("mz-memory.bin", logical)
    local f = assert(io.open("mz-state.txt","w"))
    f:write(string.format("selected=%d\n",selected))
    for i=1,8 do f:write(string.format("window%d=%d\n",i-1,windows[i])) end
    f:write(string.format("badmode=%d\nr4=%d\nr5=%d\nfirst_badmode=%d\nfirst_badaddr=%d\nfirst_badvalue=%d\n", badmode, regs[5], regs[6], badmode_r5, badmode_addr, badmode_value))
    f:close()
end
function memory_read(addr, _type, _cycles)
    local pg, off = mapped(addr), offset(addr)
    if pg == 0x30 then
        for p=0,3 do latches[p+1] = page(0x20+p*2)[off] end
        return 0
    end
    return page(pg)[off]
end
function memory_write(addr, value, _type, _cycles)
    local pg, off = mapped(addr), offset(addr)
    if pg ~= 0x30 then page(pg)[off] = value; return 0 end
    local mode = regs[6] & 0xc0
    if mode ~= 0x40 then
        if value ~= 0 then
            if badmode == 0 then badmode_r5, badmode_addr, badmode_value = regs[6], addr, value end
            badmode = 1
        end
        return 0
    end
    local en, sel = regs[5], regs[6]
    for p=0,3 do
        if (sel & (1 << p)) ~= 0 then
            local old = page(0x20+p*2)[off]
            local v = old & (~value & 0xff)
            if (en & (1 << p)) ~= 0 then v = v | (value & regs[p+1]) end
            page(0x20+p*2)[off] = v
        end
    end
    return 0
end
function io_in(addr)
    local port = addr & 0xff
    if port == 0xe8 then return pio_a end
    if port == 0xea then return keyboard:read(pio_a & 0x0f) end
    if port == 0xb5 then return windows[selected+1] end
    if port >= 0xbc and port <= 0xbf then return latches[port-0xbb] end
    return nil
end
function io_out(addr, value)
    local port = addr & 0xff; value = value & 0xff
    if port == 0xe8 then pio_a = value; return 0 end
    if port == 0xe9 or port == 0xeb then return 0 end
    if port == 0xb4 then selected = value & 7; return 0 end
    if port == 0xb5 then windows[selected+1] = value; selected = (selected + 1) & 7; return 0 end
    if port == 0xbc then regsel = value & 15; return 0 end
    if port == 0xbd then regs[regsel+1] = value; return 0 end
    if port == 0xee and (value == 1 or value == 2) then snapshot(); return 0 end
    return -1
end

function memory_mmu_text()
    return string.format("MZ-2500 windows: 0=$%02X 1=$%02X 2=$%02X 3=$%02X 4=$%02X 5=$%02X 6=$%02X 7=$%02X", windows[1], windows[2], windows[3], windows[4], windows[5], windows[6], windows[7], windows[8])
end
function memory_has_banks() return false end
function memory_bank_store(_bank, _offset, _value) return -1 end
function memory_banked_pc(_pc) return nil end
function memory_banked_caller(_saved, _ret) return nil end
function memory_reset_paging()
    for i=1,8 do windows[i] = initial_windows[i] end
    selected, regsel, badmode, badmode_r5, badmode_addr, badmode_value = 0, 0, 0, 0, 0, 0
    for i=1,16 do regs[i] = 0 end
end
