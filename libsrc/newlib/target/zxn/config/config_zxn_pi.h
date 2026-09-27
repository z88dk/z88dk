// ------------------------------------------
// Raspberry Pi GPIO
// ------------------------------------------
// Two 28-bit registers with the least significant byte first. Each bit is one GPIO pin

// A set bit enables output on that pin (pins 1:0 cannot be enabled)
#define REG_PI_GPIO_OUTPUT_ENABLE_0 0x90
#define REG_PI_GPIO_OUTPUT_ENABLE_1 0x91
#define REG_PI_GPIO_OUTPUT_ENABLE_2 0x92
#define REG_PI_GPIO_OUTPUT_ENABLE_3 0x93

// Read or write the pin state. Writes reach only the pins with output enabled
#define REG_PI_GPIO_0 0x98
#define REG_PI_GPIO_1 0x99
#define REG_PI_GPIO_2 0x9A
#define REG_PI_GPIO_3 0x9B

// ------------------------------------------
// Raspberry Pi peripheral enable
// ------------------------------------------

#define REG_PI_PERIPHERAL_ENABLE 0xA0

// Enable the uart on GPIO 14 and 15 (overrides gpio)
#define RPPE_ENABLE_UART 0x20

// Connect Rx to GPIO 14 and Tx to GPIO 15 (to talk to a pi) instead of Rx to 15 and Tx to 14 (for pi hats)
#define RPPE_UART_RX_ON_GPIO_14 0x10

// Enable I2C on GPIO 2 and 3 (overrides gpio)
#define RPPE_ENABLE_I2C 0x08

// Enable SPI on GPIO 7 to 11 (overrides gpio)
#define RPPE_ENABLE_SPI 0x01

// ------------------------------------------
// Raspberry Pi I2S audio control
// ------------------------------------------

#define REG_PI_I2S_AUDIO_CONTROL 0xA2

// I2S enable (bits 7:6)
#define RPIAC_I2S_OFF 0x00
#define RPIAC_I2S_MONO_RIGHT 0x40
#define RPIAC_I2S_MONO_LEFT 0x80
#define RPIAC_I2S_STEREO 0xC0

// PCM_DOUT from the pi and PCM_DIN to the pi (for a pi) instead of the reverse (for pi hats)
#define RPIAC_PCM_DOUT_FROM_PI 0x10

// Mute each side
#define RPIAC_MUTE_LEFT 0x08
#define RPIAC_MUTE_RIGHT 0x04

// Reserved bit that must be written as 1
#define RPIAC_RESERVED_SET 0x02

// Direct the i2s audio to EAR on port 0xfe
#define RPIAC_I2S_TO_EAR 0x01
