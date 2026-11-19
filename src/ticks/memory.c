/*
 * Memory/banking implementation for ticks
 */

#include "ticks.h"
#include "backend.h"
#include "debugger.h"
#include "ticks_lua.h"
#include <stdio.h>
#include <string.h>



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
static int      z180_handle_in(int port);
static void     rc2014_init(void);
static uint8_t *rc2014_get_memory_addr(uint32_t pc, memtype type);
static void     rc2014_handle_out(int port, int value);
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

/* Declared here so load_memory can mirror an image onto both RC2014 pages.
   rc2014_init() allocates them. A firmware load writes rc_rom only.
   An image load writes one 32 kB ROM or one 64 kB RAM page from address 0. */
static uint8_t       *rc_ram[2];
static uint8_t       *rc_rom;
static int            rc_page;
static int            rc_rom_on;
/* Latch after the image is loaded. The hotspot listing returns here. */
static int            rc_reset_page;
static int            rc_reset_rom_on;

/* Declared here so memory_reset_paging can restore the power-on map.
   z180_init() allocates the store. */
static uint8_t       *z180_mem = NULL;
static uint8_t        z180_CBAR = 0xf0;
static uint8_t        z180_CBR = 0x00;
static uint8_t        z180_BBR = 0x00;
static uint8_t        z180_ICR = 0x00;

static memory_func   get_mem_addr;
static void        (*write_hook)(uint16_t addr, uint8_t value);
static int         memory_is_write;   /* put/load: write-through under a ROM window */

// Which banking scheme the debugger has to understand.
// Z180 and RC2014 have their own maps. They are not z80asm BANK images.
static enum { MODEL_OTHER, MODEL_RABBIT, MODEL_ZXN, MODEL_MSX, MODEL_Z180, MODEL_RC2014 } current_model = MODEL_OTHER;
static int lua_memory_model = 0;
static void        (*handle_out)(int port, int value);
static int         (*handle_in)(int port);

void memory_init(char *model) {
    memory_reset_paging();
    lua_memory_model = strcmp(model, "lua") == 0;

    if ( strcmp(model,"zxn") == 0 ) {
        zxn_init();
    } else if ( strncmp(model, "zx128", 5) == 0 ) {
        zx_init(model + 5);
    } else if ( strcmp(model,"standard") == 0 ) {
        standard_init();
    } else if ( strcmp(model, "z180") == 0 ) {
        z180_init();
    } else if ( strcmp(model, "rc2014") == 0 ) {
        rc2014_init();
    } else if ( strcmp(model, "rabbit") == 0 ) {
        rabbit_init();
    } else if ( strcmp(model, "msx") == 0 ) {
        msx_init();
    } else if ( strcmp(model, "lua") == 0 ) {
        standard_init();
    } else {
        fprintf(stderr, "Unknown memory model %s\n",model);
        exit(1);
    }
}

static uint8_t logical_read(uint32_t pc, memtype type, int watchpoint)
{
  int value;
  if (watchpoint)
    bk.debugger_read_memory(pc);
  value = lua_memory_read(pc, type, st);
  if (value != -1)
    return (uint8_t)value;
  return *get_memory_addr(pc, type);
}

uint8_t get_memory(uint32_t pc, memtype type)
{
  return logical_read(pc, type, 1);
}

/* Debugger bookkeeping reads use Lua memory but do not fire watchpoints. */
uint8_t peek_memory(uint16_t pc, memtype type)
{
  return logical_read(pc, type, 0);
}

/* Image loading is a logical write, without runtime watchpoints or ROM rules. */
void load_memory(uint32_t pc, uint8_t value, memtype type)
{
  if (lua_memory_write(pc, value, type, st) != -1)
    return;
  memory_is_write = 1;
  *get_memory_addr(pc, type) = value;
  /* Port 0x30 on the 128 kB boards switches the whole 64 kB. The loaded
     image is written to both pages so the instruction after OUT 0x30 is
     still there. A later store goes to the selected page only. */
  if ( current_model == MODEL_RC2014 && rc_ram[0] != NULL ) {
    rc_ram[0][pc & 0xffff] = value;
    rc_ram[1][pc & 0xffff] = value;
  }
  memory_is_write = 0;
}

uint8_t put_memory(uint16_t pc, uint8_t b)
{
  bk.debugger_write_memory(pc, b);
  if (lua_memory_write(pc, b, MEM_TYPE_DATA, st) != -1)
    return b;
  /* -romsize protects a low ROM on the flat models. On the RC2014 a write
     in the 32 kB window still reaches the RAM page. The ROM store is not
     written. An address at 0x8000 or above keeps the -romsize rule. */
  if (pc < c_rom_size &&
      !(current_model == MODEL_RC2014 && pc < 0x8000))
    return *get_memory_addr(pc, MEM_TYPE_DATA);
  memory_is_write = 1;
  *get_memory_addr(pc, MEM_TYPE_DATA) = b;
  memory_is_write = 0;
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
    if (lua_memory_model) lua_memory_reset_paging();
    for ( i = 0; i < 8; i++ )  {
        zxnext_mmu[i] = 0xff;
    }
    /* Hotspot listing reads through this map. Restore the map from after
       the load, the same way the ZX Next slots return to 0xFF. A RAM program
       lists from page 0 with the ROM off. A firmware image lists from the ROM.
       A disk harness lists with the ROM off.
       A normal -output dump does not call this, so it still shows the final map. */
    z180_CBAR = 0xf0;
    z180_CBR = 0x00;
    z180_BBR = 0x00;
    z180_ICR = 0x00;
    rc_page = rc_reset_page;
    rc_rom_on = rc_reset_rom_on;
}

// Z180 MMU. 1 MB physical, 64 kB logical.
// CBAR[3:0] is the bank-area base and CBAR[7:4] is the common-1 base, in 4 kB units.
// Physical A19-A12 = (base + logical A15-A12) mod 256. A11-A0 pass through.
// Common 0 uses base 0, the bank area uses BBR, common 1 uses CBR.
// Reset CBAR is 0xF0 with BBR and CBR at 0, which is the low 64 kB.

#define Z180_OFF_CBR  0x38
#define Z180_OFF_BBR  0x39
#define Z180_OFF_CBAR 0x3a
#define Z180_OFF_ICR  0x3f

/* ICR[7:6] places the 64 internal registers at 0x00, 0x40, 0x80, or 0xC0.
   The low 8 port bits are the address. The high byte is not compared. */
static int z180_internal_offset(int port)
{
    if ( (port & 0xc0) != (z180_ICR & 0xc0) )
        return -1;
    return port & 0x3f;
}

static uint8_t *z180_get_memory_addr(uint32_t pc, memtype type)
{
    unsigned la = pc & 0xffff;
    unsigned page = la >> 12;
    unsigned ba = z180_CBAR & 0x0f;
    unsigned ca = z180_CBAR >> 4;
    uint8_t base = 0;
    uint32_t phys;

    if ( type == MEM_TYPE_PHYSICAL && pc > 0xffff )
        return &z180_mem[pc & 0xfffff];

    if ( page < ba )
        base = 0;
    else if ( page < ca )
        base = z180_BBR;
    else
        base = z180_CBR;

    phys = ((uint32_t)(uint8_t)(base + page) << 12) | (la & 0x0fff);
    return &z180_mem[phys & 0xfffff];
}

static void z180_handle_out(int port, int value)
{
    switch ( z180_internal_offset(port) ) {
    case Z180_OFF_CBR:
        z180_CBR = (uint8_t)value;
        break;
    case Z180_OFF_BBR:
        z180_BBR = (uint8_t)value;
        break;
    case Z180_OFF_CBAR:
        z180_CBAR = (uint8_t)value;
        break;
    case Z180_OFF_ICR:
        z180_ICR = (uint8_t)value;
        break;
    default:
        break;
    }
}

static int z180_handle_in(int port)
{
    switch ( z180_internal_offset(port) ) {
    case Z180_OFF_CBR:
        return z180_CBR;
    case Z180_OFF_BBR:
        return z180_BBR;
    case Z180_OFF_CBAR:
        return z180_CBAR;
    case Z180_OFF_ICR:
        return z180_ICR;
    default:
        return -1;
    }
}

static void z180_init(void) 
{
    z180_mem = calloc(1024*1024, sizeof(char));
    z180_CBAR = 0xf0;
    z180_CBR = 0x00;
    z180_BBR = 0x00;
    z180_ICR = 0x00;
    current_model = MODEL_Z180;
    get_mem_addr = z180_get_memory_addr;
    handle_out = z180_handle_out;
    handle_in = z180_handle_in;
}

/* The SCZ180 preamble sets CBAR to 0xE0 and CBR to 0xF0. Logical
   0xE000-0xFFFF then reads physical 0xFE000-0xFFFFF. A flat ticks file is
   one image, so that window starts as a copy of the loaded 64 kB. A later
   write to one store does not change the other. Any other bank stays 0
   until the program writes it. -b standard does not call this. */
void memory_z180_seal_common1(void)
{
    if ( current_model != MODEL_Z180 || z180_mem == NULL )
        return;
    memcpy(z180_mem + 0xF0000, z180_mem, 65536);
}

// RC2014. Port 0x38 is the standard 32 kB ROM page, on every pageable-ROM
// machine. Bit 0 = 0 maps that ROM over 0x0000-0x7FFF for reads. Bit 0 = 1
// maps RAM. Reset leaves the ROM off so a RAM program runs. A firmware image
// is loaded into the ROM store and starts with the ROM on. A write in the
// window goes to RAM and leaves the ROM store unchanged.
// Port 0x30 bit 0 is shadow RAM: a second 64 kB page on the SC108, the
// Memory Module, and the other 128 kB RAM boards. The other data bits
// are ignored.

static uint8_t *rc2014_get_memory_addr(uint32_t pc, memtype type)
{
    (void)type;
    pc &= 0xffff;
    if ( rc_rom_on && !memory_is_write && pc < 0x8000 )
        return &rc_rom[pc];
    return &rc_ram[rc_page & 1][pc];
}

static void rc2014_handle_out(int port, int value)
{
    switch ( port & 0xff ) {
    case 0x30:
        rc_page = value & 1;
        break;
    case 0x38:
        rc_rom_on = (value & 1) == 0;
        break;
    default:
        break;
    }
}

static void rc2014_init(void)
{
    rc_ram[0] = calloc(65536, 1);
    rc_ram[1] = calloc(65536, 1);
    rc_rom = calloc(32768, 1);
    memset(rc_rom, 0xff, 32768);
    rc_page = 0;
    rc_rom_on = 0;
    rc_reset_page = 0;
    rc_reset_rom_on = 0;
    current_model = MODEL_RC2014;
    get_mem_addr = rc2014_get_memory_addr;
    handle_out = rc2014_handle_out;
}

int memory_is_rc2014(void)
{
    return current_model == MODEL_RC2014;
}

/* Firmware image byte. Does not touch either RAM page. */
int memory_rc2014_load_rom(uint16_t addr, uint8_t value)
{
    if ( current_model != MODEL_RC2014 || rc_rom == NULL || addr >= 32768 )
        return 0;
    rc_rom[addr] = value;
    return 1;
}

/* ROM on, page 0. Both RAM pages stay clear. The hotspot listing
   returns to this latch, which is where the image was loaded. */
void memory_rc2014_firmware_start(void)
{
    rc_page = 0;
    rc_rom_on = 1;
    rc_reset_page = 0;
    rc_reset_rom_on = 1;
}

/* One RAM page. The ROM store is left alone. */
int memory_rc2014_load_ram(int page, uint16_t addr, uint8_t value)
{
    if ( current_model != MODEL_RC2014 || page < 0 || page > 1 || rc_ram[page] == NULL )
        return 0;
    rc_ram[page][addr] = value;
    return 1;
}

/* ROM off, page 0. The hotspot listing returns to this latch. */
void memory_rc2014_disk_start(void)
{
    rc_page = 0;
    rc_rom_on = 0;
    rc_reset_page = 0;
    rc_reset_rom_on = 0;
}

uint8_t *memory_rc2014_rom(void)
{
    return rc_rom;
}

uint8_t *memory_rc2014_ram(int page)
{
    if ( page < 0 || page > 1 )
        return NULL;
    return rc_ram[page];
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
    if (lua_memory_model) return lua_memory_has_banks();
    return current_model == MODEL_RABBIT || current_model == MODEL_ZXN || current_model == MODEL_MSX;
}

int memory_uses_lua(void)
{
    return lua_memory_model;
}

void memory_bank_store(unsigned bank, unsigned offset, uint8_t value)
{
    if (lua_memory_model) {
        if (lua_memory_bank_store(bank, offset, value) == -1) {
            fprintf(stderr, "z88dk-ticks Lua memory_write did not handle bank address %u:%04x\n", bank, offset);
            exit(EXIT_FAILURE);
        }
        return;
    }
    switch ( current_model ) {
    case MODEL_RABBIT:
        /* The bank has to be inside the physical memory (120 banks below 1MB,
           2040 below 16MB) or it would wrap on to the root image */
        if ( bank >= 1 && offset < 0x2000
             && 0x10000 + (bank - 1) * 0x2000 + offset <= rabbit_phys_mask )
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
    if (lua_memory_model) return lua_memory_banked_pc(pc);
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
     Rabbit  XPC (LXPC on the Rabbit 4000 and later), so the bank is half of it
     ZXN     the 8K page in MMU slot 6, 0xff when nothing is paged in
     MSX     the 16K page at 0x8000, below 4 when the 64k image is there */
uint32_t memory_banked_caller(uint16_t saved, uint16_t ret)
{
    uint32_t bank = 0;
    if (lua_memory_model) return lua_memory_banked_caller(saved, ret);

    switch ( current_model ) {
    case MODEL_RABBIT:
        /* XPC on the Rabbit 2000 and 3000, the 12-bit LXPC on the 4000 and later */
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

    if (lua_memory_model)
        return lua_memory_mmu_text();

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
    case MODEL_Z180:
        snprintf(buf, sizeof(buf), "cbar=%02X cbr=%02X bbr=%02X icr=%02X",
            z180_CBAR, z180_CBR, z180_BBR, z180_ICR);
        return buf;
    case MODEL_RC2014:
        snprintf(buf, sizeof(buf), "ram page=%d rom=%s",
            rc_page, rc_rom_on ? "on" : "off");
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
