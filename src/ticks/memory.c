/*
 * Memory/banking implementation for ticks
 */

#include "ticks.h"
#include "backend.h"
#include "debugger.h"
#include <stdio.h>



typedef uint8_t *(*memory_func)(uint32_t pc, memtype type);


static void     standard_init(void);
static uint8_t *standard_get_memory_addr(uint32_t pc, memtype type);
static void     zxn_init(void);
static uint8_t *zxn_get_memory_addr(uint32_t pc, memtype type);
static void     zxn_handle_out(int port, int value);
static void     zx_init(char *config);
static uint8_t *zx_get_memory_addr(uint32_t pc, memtype type);
static void     zx_handle_out(int port, int value);
static void     z180_init(void);
static uint8_t *z180_get_memory_addr(uint32_t pc, memtype type);
static void     z180_handle_out(int port, int value);
static void     rabbit_init(void);
static uint8_t *rabbit_get_memory_addr(uint32_t pc, memtype type);

static unsigned char *mem;
static unsigned char  zxnext_mmu[8] = {0xff};
static unsigned char *zxn_banks[256];

static unsigned char  zx_pages[4] = { 0x11, 0x05, 0x02, 0x00 };
static unsigned char *zx_banks[8];
static unsigned char *zx_rom[2];

static int            inst_mode = 1;       // We're reading an instruction

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
    } else if ( strcmp(model, "z180") == 0 ) {
        z180_init();
    } else if ( strcmp(model, "rabbit") == 0 ) {
        rabbit_init();
    } else {
        fprintf(stderr, "Unknown memory model %s\n",model);
        exit(1);
    }
}

uint8_t get_memory(uint32_t pc, memtype type)
{
  bk.debugger_read_memory(pc);
  return  *get_memory_addr(pc,type);
}


uint8_t put_memory(uint16_t pc, uint8_t b)
{
  bk.debugger_write_memory(pc, b);
  if (pc < rom_size)
    return *get_memory_addr(pc, MEM_TYPE_DATA);
  else
    return *get_memory_addr(pc, MEM_TYPE_DATA) = b;
}

uint8_t *get_memory_addr(uint32_t pc, memtype type)
{
    return get_mem_addr(pc, type);
}

void memory_handle_paging(int port, int value)
{
    if  ( handle_out ) {
        handle_out(port,value);
    }
}

void memory_reset_paging() 
{
    int i;
    for ( i = 0; i < 8; i++ )  {
        zxnext_mmu[i] = 0xff;
    }
}

// Z180 MMU support
static uint8_t *z180_mem = NULL;
static uint8_t z180_CBAR = 0xf0;
static uint8_t z180_CBR = 0x00;
static uint8_t z180_BBR = 0x00;

#define Z180_IO_CBR 56
#define Z180_IO_BBR 57
#define Z180_IO_CBAR 58

static uint8_t *z180_get_memory_addr(uint32_t pc, memtype type)
{
    /*
    CBAR is an 8 bit I/O port that can be accessed by the processor's OUT and IN instructions. 
    The lower 4 bits specify the starting address of the bank area, and the upper 4 give the start of common 1. 
   */
    // Are we in bank area?
    int bank_start = ((z180_CBAR) & 0x0f) << 12;
    int common1_start =  ((z180_CBAR) & 0xf0) << 8;
    if ( pc >= bank_start && pc < common1_start ) {
        // Bank area
        // Physical = Logical + (BBR * 4096)
        return &z180_mem[ (pc & 0x0fff) + (z180_BBR * 4096)];
    } else if ( pc >= common1_start ) {
        // Common 1
        // Physical = Logical + (CBR * 4096)
        return &z180_mem[ (pc & 0x0fff) + (z180_CBR * 4096)];
    }
    // Otherwise, it's common 0
    return &z180_mem[pc & 0xffff];
}

static void z180_handle_out(int port, int value)
{
    switch (port) {
    case Z180_IO_CBR:
        z180_CBR = value;
        break;
    case Z180_IO_BBR:
        z180_BBR = value;
        break;
    case Z180_IO_CBAR:
        z180_CBAR = value;
        break;
    }
}

static void z180_init(void) 
{
    z180_mem = calloc(1024*1024, sizeof(char));
    get_mem_addr = z180_get_memory_addr;
    handle_out = z180_handle_out;
}



// Standard, 64k flat address space
static void standard_init(void) 
{
    mem = calloc(65536, 1);
    get_mem_addr = standard_get_memory_addr;
}


static uint8_t *standard_get_memory_addr(uint32_t pc, memtype type)
{
  int segment = pc / 8192;
  pc &= 0xffff;

  return &mem[pc & 65535];
}


// ZXN: 256 pages of 8k, paged in at any 8k boundary
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

static uint8_t *zxn_get_memory_addr(uint32_t pc, memtype type)
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

// ZX128: 8 pages of 16k @ 0xc000 + 2 rom slots
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

static uint8_t *zx_get_memory_addr(uint32_t pc, memtype type)
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



// Rabbit - need to handle ioi/ioe
static uint8_t *ioi_mem;
static uint8_t *ioe_mem;

static uint8_t *rabbit_get_memory_addr(uint32_t pc, memtype type)
{
    pc &= 0xffff;
    if (ioi && type != MEM_TYPE_INST) {
      return &ioi_mem[pc & 65535];
    } else if (ioe && type != MEM_TYPE_INST) {
      return &ioe_mem[pc & 65535];
    }
    return &mem[pc & 65535];
}

static void rabbit_init(void) 
{
    mem = calloc(65536, 1);
    get_mem_addr = rabbit_get_memory_addr;

    ioi_mem = calloc(65536,1);
    ioe_mem = calloc(65536,1);

    // Initialse some registers here
}

// Get the value of an internal register
int rabbit_get_ioi_reg(int reg)
{
    reg &= 0xffff;

    return ioi_mem[reg];
}


