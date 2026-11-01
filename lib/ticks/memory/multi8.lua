-- Multi 8 Lua-owned 64 KB memory model for z88dk-ticks.
-- Port $2A selects active-low blue, red, green and text planes in $8000-$BFFF.

local port = 0x2f
local ram = {}
for i = 1, 0x10000 do ram[i] = 0 end
local planes = {}
for p = 1, 4 do
    planes[p] = {}
    for i = 1, 0x4000 do planes[p][i] = 0 end
end
local ports = {}
local wram_writes = 0
local snapshot

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

function memory_read(addr, _type, _cycles)
    if addr < 0x8000 or addr >= 0xc000 or port & 0x10 == 0 then return ram[addr + 1] or 0 end
    local value = 0xff
    local off = addr - 0x8000 + 1
    for p = 0, 3 do
        if port & (1 << p) == 0 then value = value & planes[p + 1][off] end
    end
    return value
end

function memory_write(addr, value, _type, cycles)
    if addr < 0x8000 or addr >= 0xc000 or port & 0x10 == 0 then
        ram[addr + 1] = value
        if addr >= 0x8000 and addr < 0xc000 and port & 0x10 == 0 and cycles > 0 then
            wram_writes = wram_writes + 1
        end
        return 0
    end
    local off = addr - 0x8000 + 1
    for p = 0, 3 do
        if port & (1 << p) == 0 then planes[p + 1][off] = value end
    end
    return 0
end

function io_out(addr, value)
    addr = addr & 0xff
    value = value & 0xff
    if addr == 0x2a then port = value
    elseif addr == 0xfe and (value == 1 or value == 2) then
        if value == 1 then
            snapshot = {}
            for p = 1, 4 do for i = 1, 0x4000 do snapshot[#snapshot + 1] = planes[p][i] end end
            export("snapshot.bin", snapshot)
        elseif value == 2 then
            local image = {}
            for p = 1, 4 do for i = 1, 0x4000 do image[#image + 1] = planes[p][i] end end
            export("planes.bin", image)
            local f = assert(io.open("model.txt", "w"))
            f:write(string.format("port=%d\nwram_writes=%d\n", port, wram_writes))
            f:close()
            f = assert(io.open("ports.txt", "w"))
            for _, item in ipairs(ports) do f:write(string.format("%d %d\n", item[1], item[2])) end
            f:close()
        end
        return 0
    else ports[#ports + 1] = { addr, value } end
    return addr == 0x2a and 0 or -1
end

function memory_mmu_text()
    return string.format("Multi 8 port $2A=$%02X planes=%s%s%s%s", port, port & 1 == 0 and "B" or "-", port & 2 == 0 and "R" or "-", port & 4 == 0 and "G" or "-", port & 8 == 0 and "T" or "-")
end

function memory_has_banks() return false end
function memory_bank_store(_bank, _offset, _value) return -1 end
function memory_banked_pc(_pc) return nil end
function memory_banked_caller(_saved, _ret) return nil end
function memory_reset_paging() port = 0x2f end
