#include "ticks.h"
#include "ticks_lua.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static lua_State *lua_state;

enum {
    LUA_IO_CONSOLE = 1u << 0,
    LUA_IO_TIMER   = 1u << 1,
    LUA_IO_APU     = 1u << 2,
    LUA_IO_ACIA    = 1u << 3,
    LUA_IO_MEMORY  = 1u << 4
};

enum {
    LUA_IO_CONSOLE_OUT = 1,
    LUA_IO_TIMER_OUT,
    LUA_IO_APU_OUT,
    LUA_IO_ACIA_OUT,
    LUA_IO_MEMORY_OUT
};

static int lua_io_native_in(lua_State *state)
{
    unsigned handler = (unsigned)lua_tointeger(state, lua_upvalueindex(1));
    int port = (int)luaL_checkinteger(state, 1);
    int value;

    switch (handler) {
    case LUA_IO_CONSOLE: value = hook_console_in(port); break;
    case LUA_IO_TIMER:   value = hook_iotimer_in(port); break;
    case LUA_IO_APU:     value = apu_in(port); break;
    case LUA_IO_ACIA:    value = acia_in(port); break;
    default:             value = memory_in(port); break;
    }
    if (value == -1)
        return 0;
    lua_pushinteger(state, value);
    return 1;
}

static void lua_io_add_native_in(const char *name, unsigned handler)
{
    lua_pushinteger(lua_state, handler);
    lua_pushcclosure(lua_state, lua_io_native_in, 1);
    lua_setfield(lua_state, -2, name);
}

static int lua_io_native_out(lua_State *state)
{
    unsigned handler = (unsigned)lua_tointeger(state, lua_upvalueindex(1));
    int port = (int)luaL_checkinteger(state, 1);
    int value = (int)luaL_checkinteger(state, 2);
    int result;

    switch (handler) {
    case LUA_IO_CONSOLE_OUT: result = hook_console_out(port, value); break;
    case LUA_IO_TIMER_OUT:   result = hook_iotimer_out(port, value); break;
    case LUA_IO_APU_OUT:     result = apu_out(port, value); break;
    case LUA_IO_ACIA_OUT:    result = acia_out(port, value); break;
    default:
        memory_handle_paging(port, value);
        result = 0;
        break;
    }
    lua_pushinteger(state, result);
    return 1;
}

static void lua_io_add_native_out(const char *name, unsigned handler)
{
    lua_pushinteger(lua_state, handler);
    lua_pushcclosure(lua_state, lua_io_native_out, 1);
    lua_setfield(lua_state, -2, name);
}

static void lua_io_error(const char *where)
{
    const char *message = lua_tostring(lua_state, -1);

    fprintf(stderr, "z88dk-ticks Lua %s: %s\n", where,
            message != NULL ? message : "non-string error");
    exit(EXIT_FAILURE);
}

int lua_io_init(const char *filename)
{
    int status;

    if (filename == NULL)
        return 0;
    lua_state = luaL_newstate();
    if (lua_state == NULL) {
        fprintf(stderr, "z88dk-ticks: could not create Lua state\n");
        return -1;
    }
    luaL_openlibs(lua_state);
    lua_newtable(lua_state);
    lua_io_add_native_in("console_in", LUA_IO_CONSOLE);
    lua_io_add_native_in("iotimer_in", LUA_IO_TIMER);
    lua_io_add_native_in("apu_in", LUA_IO_APU);
    lua_io_add_native_in("acia_in", LUA_IO_ACIA);
    lua_io_add_native_in("memory_in", LUA_IO_MEMORY);
    lua_io_add_native_out("console_out", LUA_IO_CONSOLE_OUT);
    lua_io_add_native_out("iotimer_out", LUA_IO_TIMER_OUT);
    lua_io_add_native_out("apu_out", LUA_IO_APU_OUT);
    lua_io_add_native_out("acia_out", LUA_IO_ACIA_OUT);
    lua_io_add_native_out("memory_out", LUA_IO_MEMORY_OUT);
    lua_pushinteger(lua_state, MEM_TYPE_INST);
    lua_setfield(lua_state, -2, "MEM_TYPE_INST");
    lua_pushinteger(lua_state, MEM_TYPE_DATA);
    lua_setfield(lua_state, -2, "MEM_TYPE_DATA");
    lua_pushinteger(lua_state, MEM_TYPE_STACK);
    lua_setfield(lua_state, -2, "MEM_TYPE_STACK");
    lua_pushinteger(lua_state, MEM_TYPE_LOGICAL);
    lua_setfield(lua_state, -2, "MEM_TYPE_LOGICAL");
    lua_pushinteger(lua_state, MEM_TYPE_PHYSICAL);
    lua_setfield(lua_state, -2, "MEM_TYPE_PHYSICAL");
    lua_setglobal(lua_state, "ticks");
    status = luaL_loadfile(lua_state, filename);
    if (status == LUA_OK)
        status = lua_pcall(lua_state, 0, 0, 0);
    if (status != LUA_OK)
        lua_io_error(filename);
    return 0;
}

int lua_io_in(int port)
{
    int value;

    if (lua_state == NULL)
        return -1;
    lua_getglobal(lua_state, "io_in");
    if (!lua_isfunction(lua_state, -1)) {
        lua_pop(lua_state, 1);
        return -1;
    }
    lua_pushinteger(lua_state, port);
    lua_pushinteger(lua_state, st);
    if (lua_pcall(lua_state, 2, 1, 0) != LUA_OK)
        lua_io_error("io_in");
    if (!lua_isnil(lua_state, -1)) {
        if (!lua_isinteger(lua_state, -1)) {
            fprintf(stderr, "z88dk-ticks Lua io_in must return an integer or nil\n");
            exit(EXIT_FAILURE);
        }
        value = (int)lua_tointeger(lua_state, -1);
        if (value < 0 || value > 255) {
            fprintf(stderr, "z88dk-ticks Lua io_in returned value outside 0..255\n");
            exit(EXIT_FAILURE);
        }
    } else {
        value = -1;
    }
    lua_pop(lua_state, 1);
    return value;
}

int lua_io_out(int port, int value)
{
    int result;

    if (lua_state == NULL)
        return -1;
    lua_getglobal(lua_state, "io_out");
    if (!lua_isfunction(lua_state, -1)) {
        lua_pop(lua_state, 1);
        return -1;
    }
    lua_pushinteger(lua_state, port);
    lua_pushinteger(lua_state, value);
    lua_pushinteger(lua_state, st);
    if (lua_pcall(lua_state, 3, 1, 0) != LUA_OK)
        lua_io_error("io_out");
    if (!lua_isinteger(lua_state, -1)) {
        fprintf(stderr, "z88dk-ticks Lua io_out must return an integer (-1 means unhandled)\n");
        exit(EXIT_FAILURE);
    }
    result = (int)lua_tointeger(lua_state, -1);
    lua_pop(lua_state, 1);
    return result;
}


int lua_memory_read(uint32_t address, memtype type, long long cycles)
{
    int value;

    if (lua_state == NULL)
        return -1;
    lua_getglobal(lua_state, "memory_read");
    if (!lua_isfunction(lua_state, -1)) {
        lua_pop(lua_state, 1);
        return -1;
    }
    lua_pushinteger(lua_state, address);
    lua_pushinteger(lua_state, type);
    lua_pushinteger(lua_state, cycles);
    if (lua_pcall(lua_state, 3, 1, 0) != LUA_OK)
        lua_io_error("memory_read");
    if (lua_isnil(lua_state, -1)) {
        lua_pop(lua_state, 1);
        return -1;
    }
    if (!lua_isinteger(lua_state, -1)) {
        fprintf(stderr, "z88dk-ticks Lua memory_read must return an integer or nil\n");
        exit(EXIT_FAILURE);
    }
    value = (int)lua_tointeger(lua_state, -1);
    if (value < 0 || value > 255) {
        fprintf(stderr, "z88dk-ticks Lua memory_read returned value outside 0..255\n");
        exit(EXIT_FAILURE);
    }
    lua_pop(lua_state, 1);
    return value;
}

int lua_memory_write(uint32_t address, uint8_t value, memtype type, long long cycles)
{
    int result;

    if (lua_state == NULL)
        return -1;
    lua_getglobal(lua_state, "memory_write");
    if (!lua_isfunction(lua_state, -1)) {
        lua_pop(lua_state, 1);
        return -1;
    }
    lua_pushinteger(lua_state, address);
    lua_pushinteger(lua_state, value);
    lua_pushinteger(lua_state, type);
    lua_pushinteger(lua_state, cycles);
    if (lua_pcall(lua_state, 4, 1, 0) != LUA_OK)
        lua_io_error("memory_write");
    if (!lua_isinteger(lua_state, -1)) {
        fprintf(stderr, "z88dk-ticks Lua memory_write must return an integer (-1 means unhandled)\n");
        exit(EXIT_FAILURE);
    }
    result = (int)lua_tointeger(lua_state, -1);
    lua_pop(lua_state, 1);
    return result;
}

const char *lua_memory_mmu_text(void)
{
    static char text[256];
    const char *value;
    size_t length;

    if (lua_state == NULL) return NULL;
    lua_getglobal(lua_state, "memory_mmu_text");
    if (!lua_isfunction(lua_state, -1)) { lua_pop(lua_state, 1); return NULL; }
    if (lua_pcall(lua_state, 0, 1, 0) != LUA_OK) lua_io_error("memory_mmu_text");
    if (!lua_isstring(lua_state, -1)) { lua_pop(lua_state, 1); return NULL; }
    value = lua_tostring(lua_state, -1);
    length = strlen(value);
    if (length >= sizeof(text)) length = sizeof(text) - 1;
    memcpy(text, value, length);
    text[length] = 0;
    lua_pop(lua_state, 1);
    return text;
}

static int lua_optional_function(const char *name)
{
    lua_getglobal(lua_state, name);
    if (lua_isfunction(lua_state, -1)) return 1;
    lua_pop(lua_state, 1);
    return 0;
}

int lua_memory_has_banks(void)
{
    int result;
    if (lua_state == NULL || !lua_optional_function("memory_has_banks")) return 0;
    if (lua_pcall(lua_state, 0, 1, 0) != LUA_OK) lua_io_error("memory_has_banks");
    result = lua_toboolean(lua_state, -1); lua_pop(lua_state, 1); return result;
}

int lua_memory_bank_store(unsigned bank, unsigned offset, uint8_t value)
{
    int result;
    if (lua_state == NULL || !lua_optional_function("memory_bank_store")) return -1;
    lua_pushinteger(lua_state, bank); lua_pushinteger(lua_state, offset); lua_pushinteger(lua_state, value);
    if (lua_pcall(lua_state, 3, 1, 0) != LUA_OK) lua_io_error("memory_bank_store");
    if (!lua_isinteger(lua_state, -1)) { fprintf(stderr, "z88dk-ticks Lua memory_bank_store must return an integer\n"); exit(EXIT_FAILURE); }
    result=(int)lua_tointeger(lua_state,-1); lua_pop(lua_state,1); return result;
}

uint32_t lua_memory_banked_pc(uint16_t pc)
{
    uint32_t result;
    if (lua_state == NULL || !lua_optional_function("memory_banked_pc")) return pc;
    lua_pushinteger(lua_state, pc);
    if (lua_pcall(lua_state, 1, 1, 0) != LUA_OK) lua_io_error("memory_banked_pc");
    if (lua_isnil(lua_state,-1)) result=pc;
    else if (!lua_isinteger(lua_state,-1)) { fprintf(stderr, "z88dk-ticks Lua memory_banked_pc must return an integer or nil\n"); exit(EXIT_FAILURE); }
    else result=(uint32_t)lua_tointeger(lua_state,-1);
    lua_pop(lua_state,1); return result;
}

uint32_t lua_memory_banked_caller(uint16_t saved, uint16_t ret)
{
    uint32_t result;
    if (lua_state == NULL || !lua_optional_function("memory_banked_caller")) return ret;
    lua_pushinteger(lua_state,saved); lua_pushinteger(lua_state,ret);
    if (lua_pcall(lua_state,2,1,0) != LUA_OK) lua_io_error("memory_banked_caller");
    if (lua_isnil(lua_state,-1)) result=ret;
    else if (!lua_isinteger(lua_state,-1)) { fprintf(stderr, "z88dk-ticks Lua memory_banked_caller must return an integer or nil\n"); exit(EXIT_FAILURE); }
    else result=(uint32_t)lua_tointeger(lua_state,-1);
    lua_pop(lua_state,1); return result;
}

void lua_memory_reset_paging(void)
{
    if (lua_state == NULL || !lua_optional_function("memory_reset_paging")) return;
    if (lua_pcall(lua_state,0,0,0) != LUA_OK) lua_io_error("memory_reset_paging");
}
