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
static int      zxn_handle_in(int port);
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
static void     rabbit_write_hook(uint16_t addr, uint8_t value);
static void     msx_init(void);
static uint8_t *msx_get_memory_addr(uint32_t pc, memtype type);
static void     msx_handle_out(int port, int value);
static int      msx_handle_in(int port);

static unsigned char *mem;
static unsigned char *vm1_bank1;
static unsigned char  zxnext_mmu[8] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
static unsigned char *zxn_banks[256];


static unsigned char  msx_mmu[4] = { 0x00, 0x01, 0x02, 0x03 };
static unsigned char *msx_banks[256];

static unsigned char  zx_pages[4] = { 0x11, 0x05, 0x02, 0x00 };
static unsigned char *zx_banks[8];
static unsigned char *zx_rom[2];

static int            inst_mode = 1;       // We're reading an instruction

static memory_func   get_mem_addr;
static void        (*write_hook)(uint16_t addr, uint8_t value);

// Which banking scheme the debugger has to understand
static enum { MODEL_OTHER, MODEL_RABBIT, MODEL_ZXN, MODEL_MSX } current_model = MODEL_OTHER;
static void        (*handle_out)(int port, int value);
static int         (*handle_in)(int port);

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
    } else if ( strcmp(model, "msx") == 0 ) {
        msx_init();
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
  if (pc < c_rom_size)
    return *get_memory_addr(pc, MEM_TYPE_DATA);
  *get_memory_addr(pc, MEM_TYPE_DATA) = b;
  if (write_hook)
    write_hook(pc, b);
  return b;
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

int memory_in(int port)
{
    if ( handle_in ) {
        return handle_in(port);
    }
    return -1;
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
    /* The KR580VM1 has a second 64k bank that holds data only - instructions
       are always fetched from the main bank. */
    if ( isvm1() ) vm1_bank1 = calloc(65536, 1);
    get_mem_addr = standard_get_memory_addr;
}


static uint8_t *standard_get_memory_addr(uint32_t pc, memtype type)
{
  int segment = pc / 8192;
  pc &= 0xffff;

  if ( vm1_bank1 && type == MEM_TYPE_DATA && vm1_bank_select() )
    return &vm1_bank1[pc];

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
    current_model = MODEL_ZXN;
    get_mem_addr = zxn_get_memory_addr;
    handle_out = zxn_handle_out;
    handle_in = zxn_handle_in;
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


/* Next registers: a write to port 0x243b selects a register, and the select
   stays until the next one. Port 0x253b reads and writes the selected
   register. Only the MMU slots, registers 0x50 to 0x57, are modelled. */
static int zxn_selected_register = -1;

static void zxn_handle_out(int port, int value)
{
  if ( port == 0x243B ) {
      zxn_selected_register = value;
      return;
  }
  if ( port == 0x253B && zxn_selected_register >= 0x50 && zxn_selected_register <= 0x57 ) {
    zxnext_mmu[zxn_selected_register - 0x50] = value;
  }
}

static int zxn_handle_in(int port)
{
  if ( port == 0x253B && zxn_selected_register >= 0x50 && zxn_selected_register <= 0x57 )
    return zxnext_mmu[zxn_selected_register - 0x50];
  return -1;
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



// Rabbit - segmented logical space over a flat physical array, plus ioi/ioe
static uint8_t *ioi_mem;
static uint8_t *ioe_mem;
static uint8_t *rabbit_phys;
static uint32_t rabbit_phys_mask;
static uint16_t rabbit_xpc;
static uint8_t  rabbit_mmu_segsize = 0xff;
static uint16_t rabbit_mmu_dataseg;     /* 4k units: 8 bits on R2K/R3K, 12 on R4K and later */
static uint16_t rabbit_mmu_stackseg;
// Offset added to a logical address, indexed by its top nibble
static uint32_t rabbit_seg_off[16];

#define RABBIT_IO_MMIDR     0x0010
#define RABBIT_IO_STACKSEG  0x0011
#define RABBIT_IO_DATASEG   0x0012
#define RABBIT_IO_SEGSIZE   0x0013
/* Rabbit 4000 and later: 12 bit segment offsets in a low and a high register */
#define RABBIT_IO_STKSEGL   0x001a
#define RABBIT_IO_STKSEGH   0x001b
#define RABBIT_IO_DATSEGL   0x001e
#define RABBIT_IO_DATSEGH   0x001f

static void rabbit_remap(void)
{
    int data_n = rabbit_mmu_segsize & 0x0f;
    int stack_n = rabbit_mmu_segsize >> 4;
    int n;

    for ( n = 0; n < 16; n++ ) {
        if ( n >= 0xe )
            rabbit_seg_off[n] = (uint32_t)rabbit_xpc << 12;
        else if ( n >= stack_n )
            rabbit_seg_off[n] = (uint32_t)rabbit_mmu_stackseg << 12;
        else if ( n >= data_n )
            rabbit_seg_off[n] = (uint32_t)rabbit_mmu_dataseg << 12;
        else
            rabbit_seg_off[n] = 0;
    }
}

static void rabbit_io_write(uint16_t reg, uint8_t value)
{
    int wide = (c_cpu & (CPU_R4K|CPU_R6K)) != 0;

    switch ( reg ) {
    case RABBIT_IO_STACKSEG:
        rabbit_mmu_stackseg = value;
        if ( wide ) {
            ioi_mem[RABBIT_IO_STKSEGL] = value;
            ioi_mem[RABBIT_IO_STKSEGH] = 0;
        }
        break;
    case RABBIT_IO_DATASEG:
        rabbit_mmu_dataseg = value;
        if ( wide ) {
            ioi_mem[RABBIT_IO_DATSEGL] = value;
            ioi_mem[RABBIT_IO_DATSEGH] = 0;
        }
        break;
    case RABBIT_IO_STKSEGL:
        if ( !wide ) return;
        rabbit_mmu_stackseg = (rabbit_mmu_stackseg & 0x0f00) | value;
        ioi_mem[RABBIT_IO_STACKSEG] = value;
        break;
    case RABBIT_IO_STKSEGH:
        if ( !wide ) return;
        ioi_mem[RABBIT_IO_STKSEGH] = value & 0x0f;
        rabbit_mmu_stackseg = (rabbit_mmu_stackseg & 0x00ff) | (value & 0x0f) << 8;
        break;
    case RABBIT_IO_DATSEGL:
        if ( !wide ) return;
        rabbit_mmu_dataseg = (rabbit_mmu_dataseg & 0x0f00) | value;
        ioi_mem[RABBIT_IO_DATASEG] = value;
        break;
    case RABBIT_IO_DATSEGH:
        if ( !wide ) return;
        ioi_mem[RABBIT_IO_DATSEGH] = value & 0x0f;
        rabbit_mmu_dataseg = (rabbit_mmu_dataseg & 0x00ff) | (value & 0x0f) << 8;
        break;
    case RABBIT_IO_SEGSIZE:
        rabbit_mmu_segsize = value;
        break;
    default:
        return;
    }
    rabbit_remap();
}

static uint8_t *rabbit_get_memory_addr(uint32_t pc, memtype type)
{
    // A 32-bit pointer of 0xffff:addr is a logical address
    if ( type == MEM_TYPE_PHYSICAL && (pc & 0xffff0000) != 0xffff0000 )
        return &rabbit_phys[pc & rabbit_phys_mask];

    pc &= 0xffff;
    if (ioi && type != MEM_TYPE_INST) {
      return &ioi_mem[pc];
    } else if (ioe && type != MEM_TYPE_INST) {
      return &ioe_mem[pc];
    }
    return &rabbit_phys[(pc + rabbit_seg_off[pc >> 12]) & rabbit_phys_mask];
}

static void rabbit_init(void) 
{
    // The allocation is untouched until used, so the larger size costs nothing
    rabbit_phys = calloc(16 * 1024 * 1024, 1);
    rabbit_phys_mask = (c_cpu & (CPU_R4K|CPU_R6K)) ? 0xffffff : 0xfffff;
    current_model = MODEL_RABBIT;
    get_mem_addr = rabbit_get_memory_addr;
    write_hook = rabbit_write_hook;

    ioi_mem = calloc(65536,1);
    ioe_mem = calloc(65536,1);

    ioi_mem[RABBIT_IO_SEGSIZE] = rabbit_mmu_segsize;
    rabbit_xpc = 0;
    rabbit_remap();
}

// An internal I/O write may change the memory map
static void rabbit_write_hook(uint16_t addr, uint8_t value)
{
    if ( ioi )
        rabbit_io_write(addr, value);
}

uint8_t rabbit_phys_read(uint32_t addr)
{
    return rabbit_phys[addr & rabbit_phys_mask];
}

void rabbit_phys_write(uint32_t addr, uint8_t value)
{
    rabbit_phys[addr & rabbit_phys_mask] = value;
}

/* A banked address is bank << 16 | window address, as z80asm lays out the
   bank sections. Bank N is seen at XPC = N * 2. */
uint32_t rabbit_banked_pc(uint16_t addr)
{
    if ( rabbit_phys && addr >= 0xe000 && rabbit_xpc >= 2 && (rabbit_xpc & 1) == 0 )
        return (uint32_t)(rabbit_xpc / 2) << 16 | addr;
    return addr;
}

/* The physical address behind a debugger address: a banked address in the
   window, otherwise a physical address as it is */
uint32_t rabbit_debug_physical(uint32_t addr)
{
    if ( (addr & 0xffff) >= 0xe000 && addr > 0xffff )
        return (addr >> 16) * 0x2000 + 0xe000 + (addr & 0x1fff);
    return addr;
}

const char *rabbit_mmu_text(void)
{
    static char buf[160];

    if ( !rabbit_phys )
        return NULL;
    snprintf(buf, sizeof(buf), "xpc=%0*X%s segsize=%02X dataseg=%03X stackseg=%03X",
        (c_cpu & (CPU_R4K|CPU_R6K)) ? 3 : 2, rabbit_xpc,
        (rabbit_xpc >= 2 && (rabbit_xpc & 1) == 0) ? "" : " (not a bank)",
        rabbit_mmu_segsize, rabbit_mmu_dataseg, rabbit_mmu_stackseg);
    return buf;
}

uint16_t rabbit_get_xpc(void)
{
    return rabbit_xpc;
}

void rabbit_set_xpc(uint16_t value)
{
    rabbit_xpc = value;
    rabbit_remap();
}

// Get the value of an internal register
int rabbit_get_ioi_reg(int reg)
{
    reg &= 0xffff;

    return ioi_mem[reg];
}


/* Debugger view of banked memory. A bank is addressed as bank << 16 | address
   in the bank window, which is how z80asm lays out the bank sections:
     Rabbit  bank N is XPC = N * 2 in 0xe000-0xffff
     ZXN     bank N is the 8k page N (and N+1) in MMU slots 6 and 7, 0xc000-0xffff
     MSX     bank N is the 16k page N in 0x8000-0xbfff, pages 4 and up being
             the pages above the four that hold the 64k image */

/* Loading a bank image (the _BANK_nn.bin files that z80asm writes). nn is the
   bank number as in the section names, and offset is the byte in the file.
     Rabbit  8K at physical 0x10000 + (nn - 1) * 0x2000
     ZXN     16K over the 8K pages nn and nn + 1
     MSX     16K in the 16K page nn */
int memory_has_banks(void)
{
    return current_model != MODEL_OTHER;
}

void memory_bank_store(unsigned bank, unsigned offset, uint8_t value)
{
    switch ( current_model ) {
    case MODEL_RABBIT:
        if ( bank >= 1 && offset < 0x2000 )
            rabbit_phys_write(0x10000 + (bank - 1) * 0x2000 + offset, value);
        break;
    case MODEL_ZXN:
        if ( bank + (offset >> 13) < 256 && offset < 0x4000 )
            zxn_banks[bank + (offset >> 13)][offset & 0x1fff] = value;
        break;
    case MODEL_MSX:
        if ( bank < 256 && offset < 0x4000 )
            msx_banks[bank][offset] = value;
        break;
    default:
        break;
    }
}

// pc extended with the bank mapped in its window, or pc if it is in none
uint32_t memory_banked_pc(uint16_t pc)
{
    switch ( current_model ) {
    case MODEL_RABBIT:
        return rabbit_banked_pc(pc);
    case MODEL_ZXN:
        if ( pc >= 0xc000 && zxnext_mmu[6] != 0xff )
            return (uint32_t)zxnext_mmu[6] << 16 | pc;
        break;
    case MODEL_MSX:
        if ( pc >= 0x8000 && pc < 0xc000 && msx_mmu[2] >= 4 )
            return (uint32_t)msx_mmu[2] << 16 | pc;
        break;
    default:
        break;
    }
    return pc;
}

// Where a debugger address lives. Addresses up to 64k are logical ones.
uint8_t *memory_debug_addr(uint32_t addr, memtype type)
{
    uint32_t bank = addr >> 16;
    uint16_t off = addr & 0xffff;

    if ( bank == 0 )
        return get_memory_addr(off, type);

    switch ( current_model ) {
    case MODEL_RABBIT:
        return get_memory_addr(rabbit_debug_physical(addr), MEM_TYPE_PHYSICAL);
    case MODEL_ZXN:
        if ( off >= 0xc000 && bank + (off >> 13) - 6 < 256 )
            return &zxn_banks[bank + (off >> 13) - 6][off & 0x1fff];
        break;
    case MODEL_MSX:
        if ( off >= 0x8000 && off < 0xc000 && bank < 256 )
            return &msx_banks[bank][off & 0x3fff];
        break;
    default:
        break;
    }
    return get_memory_addr(off, type);
}

/* The code that made a banked call, from its return address and the bank that
   banked_call saved. The saved byte is what the banking code reads back:
     Rabbit  XPC, so the bank is half of it
     ZXN     the 8K page in MMU slot 6, 0xff when nothing is paged in
     MSX     the 16K page at 0x8000, below 4 when the 64k image is there */
uint32_t memory_banked_caller(uint8_t saved, uint16_t ret)
{
    uint32_t bank = 0;

    switch ( current_model ) {
    case MODEL_RABBIT:
        if ( saved >= 2 && (saved & 1) == 0 && ret >= 0xe000 )
            bank = saved / 2;
        break;
    case MODEL_ZXN:
        if ( saved != 0xff && saved != 0 && ret >= 0xc000 )
            bank = saved;
        break;
    case MODEL_MSX:
        if ( saved >= 4 && ret >= 0x8000 && ret < 0xc000 )
            bank = saved;
        break;
    default:
        break;
    }
    return bank << 16 | ret;
}

// One line describing the memory map, or NULL
const char *memory_mmu_text(void)
{
    static char buf[160];
    int         i, n;

    switch ( current_model ) {
    case MODEL_RABBIT:
        return rabbit_mmu_text();
    case MODEL_ZXN:
        n = snprintf(buf, sizeof(buf), "mmu slots:");
        for ( i = 0; i < 8; i++ )
            n += snprintf(buf + n, sizeof(buf) - n, " %d=%02x", i, zxnext_mmu[i]);
        return buf;
    case MODEL_MSX:
        snprintf(buf, sizeof(buf), "pages: 0=%02x 1=%02x 2=%02x 3=%02x",
            msx_mmu[0], msx_mmu[1], msx_mmu[2], msx_mmu[3]);
        return buf;
    default:
        return NULL;
    }
}


// MSX: 256 pages of 16k, paged in at a 16k boundary
static void msx_init(void) 
{
    int  i;

    for ( i = 0; i < 256; i++ ) {
        msx_banks[i] = calloc(16384,1);
    }
    msx_mmu[0] = 0x00;
    msx_mmu[1] = 0x01;
    msx_mmu[2] = 0x02;
    msx_mmu[3] = 0x03;

    current_model = MODEL_MSX;
    get_mem_addr = msx_get_memory_addr;
    handle_out = msx_handle_out;
    handle_in = msx_handle_in;
}

static uint8_t *msx_get_memory_addr(uint32_t pc, memtype type)
{
  int segment = pc / 16384;

  return &msx_banks[msx_mmu[segment]][pc % 16384];
}

static int msx_handle_in(int port)
{
  switch ( port & 0xff ) {
  case 0xfc:
    return msx_mmu[0];
    break;
  case 0xfd:
    return msx_mmu[1];
    break;
  case 0xfe:
    return msx_mmu[2];
    break;
  case 0xff:
    return msx_mmu[3];
    break;
  }
  return -1;
}

static void msx_handle_out(int port, int value)
{
  switch ( port & 0xff ) {
  case 0xfc:
    msx_mmu[0] = value;
    break;
  case 0xfd:
    msx_mmu[1] = value;
    break;
  case 0xfe:
    msx_mmu[2] = value;
    break;
  case 0xff:
    msx_mmu[3] = value;
    break;
  }
  return;
}
