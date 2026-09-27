// ------------------------------------------
// ESP wifi GPIO
// ------------------------------------------

// Output enable for the ESP GPIO pins (GPIO2 is read only so its enable is fixed at 0)
#define REG_ESP_GPIO_OUTPUT_ENABLE 0xA8

// Read or write the ESP GPIO pins
#define REG_ESP_GPIO 0xA9

// Bits of both registers above
#define RESPG_GPIO0 0x01
#define RESPG_GPIO2 0x04
