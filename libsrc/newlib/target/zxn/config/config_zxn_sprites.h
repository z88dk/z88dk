// ------------------------------------------
// Hardware sprites registers and flags
// ------------------------------------------

// Register for selection of the active sprite attribute and pattern slot index
#define REG_SPRITE_NUMBER 0x34

// Low 8 bits of sprite X position registers
#define REG_SPRITE_ATTR_X 0x35
#define REG_SPRITE_ATTR_0 0x35
#define REG_SPRITE_ATTR_X_INCREMENT 0x75
#define REG_SPRITE_ATTR_0_INCREMENT 0x75

// Low 8 bits of sprite Y position registers
#define REG_SPRITE_ATTR_Y 0x36
#define REG_SPRITE_ATTR_1 0x36
#define REG_SPRITE_ATTR_Y_INCREMENT 0x76
#define REG_SPRITE_ATTR_1_INCREMENT 0x76

// Sprite attr 2 registers
#define REG_SPRITE_ATTR2 0x37
#define REG_SPRITE_ATTR2_INCREMENT 0x77

// Sprite attr 2 flags
#define RSA2_ENABLE_X_MIRRORING 0x08
#define RSA2_ENABLE_Y_MIRRORING 0x04
#define RSA2_ROTATE_CLOCKWISE 0x02
#define RSA2_RELATIVE_ANCHOR_PALETTE 0x01

// Sprite attr 3 registers
#define REG_SPRITE_ATTR3 0x38
#define REG_SPRITE_ATTR3_INCREMENT 0x78

// Sprite attr 3 flags
#define RSA3_VISIBLE 0x80
#define RSA3_USE_BYTE_4 0x40

// Sprite attr 4 register
#define REG_SPRITE_ATTR4 0x39
#define REG_SPRITE_ATTR4_INCREMENT 0x79

// Sprite attr 4 flags for anchor sprites
#define RSA4_ANCHOR_SPRITE_8BIT 0b00000000
#define RSA4_ANCHOR_SPRITE_4BIT_0_127_PATTERN 0b10000000
#define RSA4_ANCHOR_SPRITE_4BIT_128_255_PATTERN 0b11000000
#define RSA4_ANCHOR_UNIFIED 0b00100000
#define RSA4_ANCHOR_COMPOSITE 0b00000000

// Sprite attr 4 flags for composite relative sprites
#define RSA4_RELATIVE_SPRITE 0b01000000
#define RSA4_RELATIVE_ANCHOR_PATTERN 0b00000001

// Sprite attr 4 flags for scaling
#define RSA4_X_SCALE_2X 0b00001000
#define RSA4_X_SCALE_4X 0b00010000
#define RSA4_X_SCALE_8X 0b00011000
#define RSA4_Y_SCALE_2X 0b00000100
#define RSA4_Y_SCALE_4X 0b00000010
#define RSA4_Y_SCALE_8X 0b00000110

// ----------------------------------------------------------------------------
// Sprite flags for Sprite and Layers System register (REG_SPRITE_LAYER_SYSTEM)
// ----------------------------------------------------------------------------

// Enable cliping of sprites over the border
#define RSLS_ENABLE_SPRITES_CLIPING_OVER_BORDER 0x20
