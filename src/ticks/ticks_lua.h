#ifndef TICKS_LUA_H
#define TICKS_LUA_H

#include "memory.h"
#include <stdint.h>

int lua_io_init(const char *filename);
int lua_io_in(int port);
int lua_io_out(int port, int value);
int lua_memory_read(uint32_t address, memtype type, long long cycles);
int lua_memory_write(uint32_t address, uint8_t value, memtype type, long long cycles);
const char *lua_memory_mmu_text(void);
int lua_memory_has_banks(void);
int lua_memory_bank_store(unsigned bank, unsigned offset, uint8_t value);
uint32_t lua_memory_banked_pc(uint16_t pc);
uint32_t lua_memory_banked_caller(uint16_t saved, uint16_t ret);
void lua_memory_reset_paging(void);

#endif
