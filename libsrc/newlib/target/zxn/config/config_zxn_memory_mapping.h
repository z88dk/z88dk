// ------------------------------------------
// Alternate ROM
// ------------------------------------------
// Bits 7:4 take effect immediately. Bits 3:0 are copied into bits 7:4 on a soft reset

#define REG_ALTERNATE_ROM 0x8C

// Enable the alternate rom
#define RAR_ENABLE 0x80

// Make the alternate rom visible only during writes instead of replacing the rom during reads
#define RAR_WRITE_ONLY 0x40

// Lock ROM1 (the 48K rom) and ROM0 (the 128K rom). Applies even while the alternate rom is disabled
#define RAR_LOCK_ROM1 0x20
#define RAR_LOCK_ROM0 0x10

// The same settings applied on the next soft reset
#define RAR_ENABLE_ON_SOFT_RESET 0x08
#define RAR_WRITE_ONLY_ON_SOFT_RESET 0x04
#define RAR_LOCK_ROM1_ON_SOFT_RESET 0x02
#define RAR_LOCK_ROM0_ON_SOFT_RESET 0x01

// ------------------------------------------
// Spectrum 128K memory mapping
// ------------------------------------------
// A single register view of ports 0x7ffd and 0xdffd and 0x1ffd. Writes take
// effect at once as if made through the ports

#define REG_SPECTRUM_128K_MAPPING 0x8E

// RAM bank 0-15 in bits 7:4 (port 0xdffd bit 0 and port 0x7ffd bits 2:0)
#define RSM_RAM_BANK_MASK 0xF0

// Write 1 to change the RAM bank. Always reads as 1
#define RSM_CHANGE_RAM_BANK 0x08

// Paging mode: special all RAM (port 0x1ffd bit 0)
#define RSM_ALL_RAM 0x04

// ROM select or the all RAM configuration when RSM_ALL_RAM is set (bits 1:0)
#define RSM_ROM_MASK 0x03
#define RSM_ALL_RAM_MASK 0x03

// ------------------------------------------
// Memory mapping mode
// ------------------------------------------
// How ports 0x7ffd and 0xdffd and 0x1ffd and 0xeff7 page memory

#define REG_MEMORY_MAPPING_MODE 0x8F

#define RMMM_ZX_128K_P3 0x00
#define RMMM_PENTAGON_512K 0x02
#define RMMM_PENTAGON_1024K 0x03
