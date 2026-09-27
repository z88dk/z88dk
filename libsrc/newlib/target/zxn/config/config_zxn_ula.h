// ------------------------------------------
// ULA control and display control registers
// ------------------------------------------

// Controls the ULA output and how it is blended with the tilemap
#define REG_ULA_CONTROL 0x68

// Disable the ULA output
#define RUC_DISABLE_ULA_OUTPUT 0x80

// Blending in SLU modes 6 and 7 (bits 6:5)
#define RUC_ULA_AS_BLEND_COLOR 0x00
#define RUC_NO_BLENDING 0x20
#define RUC_ULA_TILEMAP_MIX_AS_BLEND_COLOR 0x40
#define RUC_TILEMAP_AS_BLEND_COLOR 0x60

// Cancel entries in the 8x5 matrix for the extended keys
#define RUC_CANCEL_EXTENDED_KEYS_IN_MATRIX 0x10

// Enable ULA+
#define RUC_ENABLE_ULA_PLUS 0x08

// ULA half pixel scroll
#define RUC_HALF_PIXEL_SCROLL 0x04

// Enable stencil mode when both the ULA and the tilemap are enabled
#define RUC_ENABLE_STENCIL_MODE 0x01

// ------------------------------------------
// Display control 1
// ------------------------------------------

// Enables layer 2 and the ULA shadow display and aliases the Timex display modes
#define REG_DISPLAY_CONTROL 0x69

// Enable layer 2 (alias of port 0x123B bit 1)
#define RDC_ENABLE_LAYER_2 0x80

// Enable the ULA shadow display (alias of port 0x7FFD bit 3)
#define RDC_ENABLE_ULA_SHADOW_DISPLAY 0x40

// Timex display mode bits (alias of port 0xFF bits 5:0)
#define RDC_TIMEX_DISPLAY_MODE_MASK 0x3F

// ------------------------------------------
// ULA scroll
// ------------------------------------------

// ULA X offset (0-255)
#define REG_ULA_OFFSET_X 0x26

// ULA Y offset (0-191)
#define REG_ULA_OFFSET_Y 0x27

// ------------------------------------------
// LoRes control
// ------------------------------------------

#define REG_LORES_CONTROL 0x6A

// LoRes is Radastan mode: 128x96x4 in 6144 bytes
#define RLC_RADASTAN_MODE 0x20

// Radastan Timex display file xor
#define RLC_RADASTAN_TIMEX_XOR 0x10

// Palette offset occupies the four low bits (only bits 1:0 apply in ULA+ mode)
#define RLC_PALETTE_OFFSET_MASK 0x0F
