/*
 * Memory/banking implementation for ticks
 */

#include "ticks.h"
#include <stdio.h>



typedef uint8_t *(*memory_func)(int pc);


static void     standard_init(void);
static uint8_t *standard_get_memory_addr(int pc);
static void     zxn_init(void);
static uint8_t *zxn_get_memory_addr(int pc);
static void     zxn_handle_out(int port, int value);


static unsigned char *mem;
static unsigned char  zxnext_mmu[8] = {0xff};
static unsigned char *zxn_banks[256];

static memory_func   get_mem_addr;
static void        (*handle_out)(int port, int value);

void memory_init(const char *model) {
    memory_reset_paging();
    if ( strcmp(model,"zxn") == 0 ) {
        zxn_init();
    } else if ( strcmp(model,"standard") == 0 ) {
        standard_init();
    } else {
        fprintf(stderr, "Unknown memory model %s\n",model);
        exit(1);
    }
}

uint8_t get_memory(int pc)
{
  return  *get_memory_addr(pc);
}

uint8_t put_memory(int pc, uint8_t b)
{
  return *get_memory_addr(pc) = b;
}

uint8_t *get_memory_addr(int pc)
{
    return get_mem_addr(pc);
}

void memory_handle_paging(int port, int value)
{
    if  ( handle_out ) {
        handle_out(port,value);
    }
}

static void standard_init(void) 
{
    mem = calloc(65536, 0);
    get_mem_addr = standard_get_memory_addr;
}

void memory_reset_paging() 
{
    int i;
    for ( i = 0; i < 8; i++ )  {
        zxnext_mmu[i] = 0xff;
    }
}

static uint8_t *standard_get_memory_addr(int pc)
{
  int segment = pc / 8192;
  pc &= 0xffff;

  return &mem[pc & 65535];
}

static void zxn_init(void) 
{
    int  i;

    for ( i = 0; i < 256; i++ ) {
        zxn_banks[i] = calloc(8192,1);
    }


    standard_init();
    get_mem_addr = zxn_get_memory_addr;
    handle_out = zxn_handle_out;
}

static uint8_t *zxn_get_memory_addr(int pc)
{
  int segment = pc / 8192;
  pc &= 0xffff;

  if ( zxnext_mmu[segment] != 0xff ) {
    return &zxn_banks[zxnext_mmu[segment]][pc % 8192];
  }
  return &mem[pc & 65535];
}


static void zxn_handle_out(int port, int value)
{
  static int nextport = 0;

  if ( port == 0x243B && nextport == 0 ) {
      nextport = value;
      return;
  }
  if ( nextport >= 0x50 && nextport <= 0x57 ) {
    zxnext_mmu[nextport - 0x50] = value;
  }
  nextport = 0;
  return;
}
