// ------------------------------------------
// Copper 16-bit data write
// ------------------------------------------
// Values are written in pairs: first the MSB for an even copper address and
// then the LSB for an odd copper address. The whole 16-bit instruction is
// stored at once after the LSB is written. The copper address auto-increments
// after each write

#define REG_COPPER_DATA_16 0x63
