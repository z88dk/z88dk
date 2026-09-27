// ------------------------------------------
// DAC mirror registers
// ------------------------------------------
// Writing sends an 8-bit sample to the corresponding side. Reading returns the
// MSB of the current I2S sample whose LSB is latched into REG_DAC_MONO (0x2D)
// These registers let the copper drive the stereo DACs

// 8-bit sample written to the left side DAC B
#define REG_DAC_LEFT 0x2C

// 8-bit sample written to the right side DAC C
#define REG_DAC_RIGHT 0x2E
