// ------------------------------------------
// Hardware tilemap (aka layer 3) registers
// ------------------------------------------

// Sets and reads the clip-window for Tilemap graphics
#define REG_CLIP_WINDOW_TILEMAP 0x1B

// Sets the X pixel offset (two high bits) used for drawing Tilemap graphics on the screen
#define REG_TILEMAP_OFFSET_X_MSB 0x2f

// Sets the X pixel offset (two low bits) used for drawing Tilemap graphics on the screen
#define REG_TILEMAP_OFFSET_X_LSB 0x3

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
