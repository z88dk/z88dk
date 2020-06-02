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
static void     zx_init(char *config);
static uint8_t *zx_get_memory_addr(int pc);
static void     zx_handle_out(int port, int value);

static unsigned char *mem;
static unsigned char  zxnext_mmu[8] = {0xff};
static unsigned char *zxn_banks[256];

static unsigned char  zx_pages[4] = { 0x11, 0x05, 0x02, 0x00 };
static unsigned char *zx_banks[8];
static unsigned char *zx_rom[2];

static memory_func   get_mem_addr;
static void        (*handle_out)(int port, int value);

void memory_init(char *model) {
    memory_reset_paging();

    if ( strcmp(model,"zxn") == 0 ) {
        zxn_init();
    } else if ( strncmp(model, "zx128", 5) == 0 ) {
        zx_init(model + 5);
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
  if (pc < rom_size)
    return *get_memory_addr(pc);
  else
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
    mem = calloc(65536, 1);
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

static void load_rom(char *filename, unsigned char *buf, size_t len)
{
    FILE  *fp;
    
    if ( ( fp = fopen(filename, "rb")) != NULL ) {
        if ( fread(buf, len, 1, fp) != 1 ) {
            fprintf(stderr,"Could not read whole ROM from file <%s>", filename);
            exit(1);
        }
        fclose(fp);
    } else {
        fprintf(stderr,"Could not open ROM from file <%s>", filename);
        exit(1);
    }

}

static void zx_init(char *config) 
{
    int  i;

    for ( i = 0; i < 8; i++ ) {
        zx_banks[i] = calloc(16384,1);
    }

    for ( i = 0; i < 2; i++ ) {
        zx_rom[i] = calloc(16384,1);
    }

    get_mem_addr = zx_get_memory_addr;
    handle_out = zx_handle_out;

    if ( *config == ',') {
        char *ptr = strchr(config+1,',');
        config++;
        // We've got some ROM loading config coming up
        if ( ptr != NULL ) {
            *ptr = 0;
        }
        load_rom(config, zx_rom[0], 16384);
        if ( ptr != NULL ) {
            load_rom(ptr + 1, zx_rom[1], 16384);
        }
    }
}

static uint8_t *zx_get_memory_addr(int pc)
{
    int segment = pc / 16384;
    int bank = zx_pages[segment];

    pc &= 0xffff;

    if ( bank >= 0x10 ) {
        return &zx_rom[bank - 0x10][pc % 16384];
    }

    return &zx_banks[bank][pc % 16384];
}


static void zx_handle_out(int port, int value)
{
  static int locked = 0;

  if ( port == 0x7ffd && !locked ) {
      if ( value & 0x20 ) {
          locked = 1;
          return;
      }
      zx_pages[3] = value & 0x07;

      if ( value & 16 ) {
          zx_pages[0] = 0x10; // 128k ROM
      } else {
          zx_pages[0] = 0x11; // 48k ROM
      }
  }
  return;
}
