-- PC-8801 Lua-owned 64 KB memory model for z88dk-ticks.
-- The three planes are exposed in $C000-$FFFF via ports $5C-$5F and $32-$35.

local keyboard = require("keyboard_matrix").new(13, 8)

local plane = 0
local p32, p35, alu = 0x98, 0, 0
local ram = {}
for i = 1, 0x10000 do ram[i] = 0 end
local planes, latch = {}, { 0, 0, 0 }
for p = 1, 3 do
    planes[p] = {}
    for i = 1, 0x4000 do planes[p][i] = 0 end
end
local ports = {}
local ram_writes, alu_reads = 0, 0

local function selected()
    if p32 & 0x40 ~= 0 then return p35 & 0x80 ~= 0 and 8 or 0 end
    return plane
end

local function export(path, data)
    local f = assert(io.open(path, "wb"))
    local chunk = {}
    for _, b in ipairs(data) do
        chunk[#chunk + 1] = string.char(b)
        if #chunk == 1024 then f:write(table.concat(chunk)); chunk = {} end
    end
    if #chunk > 0 then f:write(table.concat(chunk)) end
    f:close()
end

function memory_read(addr, _type, _cycles)
    if addr < 0xc000 or addr > 0xffff then return ram[addr + 1] or 0 end
    local off, s = addr - 0xc000 + 1, selected()
    if s >= 1 and s <= 3 then return planes[s][off] end
    if s == 0 then return ram[addr + 1] or 0 end
    if s == 8 then
        alu_reads = alu_reads + 1
        for p = 1, 3 do latch[p] = planes[p][off] end
    end
    return 0
end

function memory_write(addr, value, _type, cycles)
    if addr < 0xc000 or addr > 0xffff then
        ram[addr + 1] = value
        return 0
    end
    local off, s = addr - 0xc000 + 1, selected()
    if s == 0 then
        ram[addr + 1] = value
        if cycles > 0 then ram_writes = ram_writes + 1 end
        return 0
    end
    if s >= 1 and s <= 3 then
        planes[s][off] = value
    elseif s == 8 and (p35 & 0x30) == 0x10 then
        for p = 1, 3 do planes[p][off] = latch[p] end
    elseif s == 8 then
        for p = 0, 2 do
            local op = (alu >> p) & 0x11
            if op == 0 then planes[p + 1][off] = planes[p + 1][off] & (~value & 0xff)
            elseif op == 1 then planes[p + 1][off] = planes[p + 1][off] | value
            elseif op == 0x10 then planes[p + 1][off] = planes[p + 1][off] ~ value end
        end
    end
    return 0
end

function io_in(addr)
    if addr >= 0 and addr <= 0x0c then return keyboard:read(addr) end
    return nil
end

function io_out(addr, value)
    addr, value = addr & 0xff, value & 0xff
    if addr >= 0x5c and addr <= 0x5f then plane = addr == 0x5f and 0 or addr - 0x5b
    elseif addr == 0x32 then p32 = value
    elseif addr == 0x35 then p35 = value
    elseif addr == 0x34 then alu = value
    elseif addr == 0xfe and (value == 1 or value == 2) then
        if value == 1 then
            local image = {}
            for p = 1, 3 do for i = 1, 0x4000 do image[#image + 1] = planes[p][i] end end
            export("snapshot.bin", image)
        elseif value == 2 then
            local image = {}
            for p = 1, 3 do for i = 1, 0x4000 do image[#image + 1] = planes[p][i] end end
            export("planes.bin", image)
            local f = assert(io.open("model.txt", "w"))
            f:write(string.format("plane=%d\np32=%d\np35=%d\nalu=%d\nram_writes=%d\nalu_reads=%d\n", plane, p32, p35, alu, ram_writes, alu_reads))
            f:close()
            f = assert(io.open("ports.txt", "w"))
            for _, item in ipairs(ports) do f:write(string.format("%d %d\n", item[1], item[2])) end
            f:close()
        end
        return 0
    else ports[#ports + 1] = { addr, value }; return -1 end
    ports[#ports + 1] = { addr, value }
    return 0
end

function memory_mmu_text()
    local s = selected()
    return string.format("PC-8801 plane=%d p32=$%02X p35=$%02X ALU=$%02X", s, p32, p35, alu)
end

function memory_has_banks() return false end
function memory_bank_store(_bank, _offset, _value) return -1 end
function memory_banked_pc(_pc) return nil end
function memory_banked_caller(_saved, _ret) return nil end
function memory_reset_paging() plane, p32, p35, alu = 0, 0x98, 0, 0 end
