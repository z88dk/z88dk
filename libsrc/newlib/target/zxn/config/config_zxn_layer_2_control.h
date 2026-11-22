// ------------------------------------------
// Layer 2 control register and flags
// ------------------------------------------

// Selects the layer 2 resolution and palette offset
#define REG_LAYER_2_CONTROL 0x70

// Layer 2 resolution (bits 5:4)
#define RL2C_RESOLUTION_256x192x8 0x00
#define RL2C_RESOLUTION_320x256x8 0x10
#define RL2C_RESOLUTION_640x256x4 0x20

// Palette offset occupies the four low bits
#define RL2C_PALETTE_OFFSET_MASK 0x0F

// ------------------------------------------
// Layer 2 X scroll MSB
// ------------------------------------------

// Bit 0 is the MSB of the layer 2 horizontal scroll amount
#define REG_LAYER_2_OFFSET_X_MSB 0x71
