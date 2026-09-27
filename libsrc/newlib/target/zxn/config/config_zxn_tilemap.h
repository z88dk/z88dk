// ------------------------------------------
// Hardware tilemap (aka layer 3) registers
// ------------------------------------------

// Sets and reads the clip-window for Tilemap graphics
#define REG_CLIP_WINDOW_TILEMAP 0x1B

// Sets the X pixel offset (two high bits) used for drawing Tilemap graphics on the screen
#define REG_TILEMAP_OFFSET_X_MSB 0x2f

// Sets the X pixel offset (eight low bits) used for drawing Tilemap graphics on the screen
#define REG_TILEMAP_OFFSET_X_LSB 0x30

// Sets the Y pixel offset used for drawing Tilemap graphics on the screen
#define REG_TILEMAP_OFFSET_Y 0x31

// Sets the transparency index for Tilemap graphics
#define REG_TILEMAP_TRANSPARENCY_INDEX 0x4C

// ----------------------------------------------------------------
// Tilemap values for clip window control (REG_CLIP_WINDOW_CONTROL)
// ----------------------------------------------------------------

// Reset the tilemap clip index
#define RCWC_RESET_TILEMAP_CLIP_INDEX 0x08

// ------------------------------------------------------------------------
// Tilemap selection for the palette control register (REG_PALETTE_CONTROL)
// ------------------------------------------------------------------------

// Tilemap first palette
#define RPC_SELECT_TILEMAP_PALETTE_0 0x30

// Tilemap second palette
#define RPC_SELECT_TILEMAP_PALETTE_1 0x70

// ------------------------------------------
// Tilemap control register and flags
// ------------------------------------------

// Controls the tilemap mode and enables it
#define REG_TILEMAP_CONTROL 0x6B

// Enable the tilemap
#define RTC_ENABLE_TILEMAP 0x80

// Tilemap size: 40x32 (default) or 80x32
#define RTC_40x32_MODE 0x00
#define RTC_80x32_MODE 0x40

// Eliminate the attribute entry in the tilemap
#define RTC_ELIMINATE_ATTRIBUTE_BYTE 0x20

// Palette select: first (default) or second tilemap palette
#define RTC_SELECT_PALETTE_0 0x00
#define RTC_SELECT_PALETTE_1 0x10

// Select textmode
#define RTC_ACTIVATE_TEXT_MODE 0x08

// Activate 512 tile mode
#define RTC_ACTIVATE_512_TILE_MODE 0x02

// Force the tilemap on top of the ULA
#define RTC_FORCE_TILEMAP_OVER_ULA 0x01

// --------------------------------------------------
// Default tilemap attribute register and flags
// --------------------------------------------------

// Attribute applied to every tile when REG_TILEMAP_CONTROL bit 5 is set
#define REG_DEFAULT_TILEMAP_ATTRIBUTE 0x6C

// Palette offset occupies the four high bits
#define RDTA_PALETTE_OFFSET_MASK 0xF0

// Mirror the tile horizontally
#define RDTA_X_MIRROR 0x08

// Mirror the tile vertically
#define RDTA_Y_MIRROR 0x04

// Rotate the tile
#define RDTA_ROTATE 0x02

// Draw the ULA over the tilemap. In 512 tile mode this bit is bit 8 of the tile number instead
#define RDTA_ULA_OVER_TILEMAP 0x01
#define RDTA_TILE_INDEX_BIT_8 0x01

// ------------------------------------------------------
// Tilemap and tile definition base address registers
// ------------------------------------------------------

// MSB of the tilemap base address as an offset into bank 5 or bank 7
#define REG_TILEMAP_BASE_ADDRESS 0x6E

// MSB of the tile definitions base address as an offset into bank 5 or bank 7
#define REG_TILE_DEFINITIONS_BASE_ADDRESS 0x6F

// Select bank 7 rather than bank 5 for the two registers above
#define RTBA_SELECT_BANK_7 0x80
#define RTDBA_SELECT_BANK_7 0x80

// Offset within the bank occupies the six low bits
#define RTBA_OFFSET_MASK 0x3F
#define RTDBA_OFFSET_MASK 0x3F
