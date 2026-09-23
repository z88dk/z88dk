// ------------------------------------------
// Extended keys registers
// ------------------------------------------
// Nextreg 0x68 bit 4 (RUC_CANCEL_EXTENDED_KEYS_IN_MATRIX) stops the extended
// keys from making entries in the 8x5 matrix

// Read the state of the first group of extended keys
#define REG_EXTENDED_KEYS_0 0xB0

#define REK0_SEMICOLON 0x80
#define REK0_QUOTE 0x40
#define REK0_COMMA 0x20
#define REK0_PERIOD 0x10
#define REK0_UP 0x08
#define REK0_DOWN 0x04
#define REK0_LEFT 0x02
#define REK0_RIGHT 0x01

// Read the state of the second group of extended keys
#define REG_EXTENDED_KEYS_1 0xB1

#define REK1_DELETE 0x80
#define REK1_EDIT 0x40
#define REK1_BREAK 0x20
#define REK1_INV_VIDEO 0x10
#define REK1_TRUE_VIDEO 0x08
#define REK1_GRAPH 0x04
#define REK1_CAPS_LOCK 0x02
#define REK1_EXTEND 0x01
