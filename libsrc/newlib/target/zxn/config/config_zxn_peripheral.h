// ------------------------------------------
// Peripheral 5 setting
// ------------------------------------------

// Multiface type mouse dpi and mouse button order
#define REG_PERIPHERAL_5 0x0A

// Multiface type (bits 7:6) (config mode only)
#define RP5_MULTIFACE_P3 0x00
#define RP5_MULTIFACE_128_V87_2 0x40
#define RP5_MULTIFACE_128_V87_12 0x80
#define RP5_MULTIFACE_1 0xC0

// Swap sd0 and sd1 (config mode only)
#define RP5_SWAP_SD0_SD1 0x20

// Enable divmmc automap
#define RP5_ENABLE_DIVMMC_AUTOMAP 0x10

// Reverse the left and right mouse buttons
#define RP5_MOUSE_REVERSE_BUTTONS 0x08

// Mouse dpi (bits 1:0)
#define RP5_MOUSE_LOW_DPI 0x00
#define RP5_MOUSE_DEFAULT_DPI 0x01
#define RP5_MOUSE_MEDIUM_DPI 0x02
#define RP5_MOUSE_HIGH_DPI 0x03
