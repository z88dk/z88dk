// ------------------------------------------
// Expansion bus enable
// ------------------------------------------
// Bits 7:4 take effect immediately. Bits 3:0 are copied into bits 7:4 on a soft reset

#define REG_EXPANSION_BUS_ENABLE 0x80

// Enable the expansion bus
#define REBE_ENABLE 0x80

// Enable romcs rom replacement from divmmc banks 14 and 15
#define REBE_ENABLE_ROMCS_REPLACEMENT 0x40

// Disable i/o cycles and ignore iorqula
#define REBE_DISABLE_IO_CYCLES 0x20

// Disable memory cycles and ignore romcs
#define REBE_DISABLE_MEMORY_CYCLES 0x10

// The same settings applied on the next soft reset
#define REBE_ENABLE_ON_SOFT_RESET 0x08
#define REBE_ENABLE_ROMCS_REPLACEMENT_ON_SOFT_RESET 0x04
#define REBE_DISABLE_IO_CYCLES_ON_SOFT_RESET 0x02
#define REBE_DISABLE_MEMORY_CYCLES_ON_SOFT_RESET 0x01

// ------------------------------------------
// Expansion bus control
// ------------------------------------------

#define REG_EXPANSION_BUS_CONTROL 0x81

// ROMCS is asserted on the expansion bus (read only)
#define REBC_ROMCS_ASSERTED 0x80

// Allow peripherals to override the ULA on some even port reads (Rotronics Wafadrive)
#define REBC_ALLOW_ULA_OVERRIDE 0x40

// Disable the expansion bus nmi debounce (Opus Discovery)
#define REBC_DISABLE_NMI_DEBOUNCE 0x20

// Propagate the max cpu clock at all times including when the expansion bus is off
#define REBC_PROPAGATE_MAX_CPU_CLOCK 0x10

// Enable +3 fdc signals on the expansion bus (issue 5 only)
#define REBC_ENABLE_P3_FDC_SIGNALS 0x08

// Max cpu speed while the expansion bus is on (bits 1:0 and currently fixed at 3.5MHz)
#define REBC_MAX_CPU_SPEED_MASK 0x03
#define REBC_MAX_CPU_SPEED_3MHZ 0x00

// --------------------------------------------------------
// Port decoding enables
// --------------------------------------------------------
// Two 32-bit registers with the least significant byte first. A clear bit
// disables the internal device. The internal enables always apply. While the
// expansion bus is on the expansion bus enables are ANDed with them and io
// cycles to a disabled port propagate to the expansion bus

#define REG_INTERNAL_PORT_DECODING_0 0x82
#define REG_INTERNAL_PORT_DECODING_1 0x83
#define REG_INTERNAL_PORT_DECODING_2 0x84
#define REG_INTERNAL_PORT_DECODING_3 0x85

#define REG_EXPANSION_BUS_DECODING_0 0x86
#define REG_EXPANSION_BUS_DECODING_1 0x87
#define REG_EXPANSION_BUS_DECODING_2 0x88
#define REG_EXPANSION_BUS_DECODING_3 0x89

// Bits of REG_INTERNAL_PORT_DECODING_0 and REG_EXPANSION_BUS_DECODING_0
#define RPD0_PORT_FF 0x01
#define RPD0_PORT_7FFD 0x02
#define RPD0_PORT_DFFD 0x04
#define RPD0_PORT_1FFD 0x08
#define RPD0_P3_FLOATING_BUS 0x10
#define RPD0_ZXN_DMA 0x20
#define RPD0_KEMPSTON_1 0x40
#define RPD0_KEMPSTON_2 0x80

// Bits of REG_INTERNAL_PORT_DECODING_1 and REG_EXPANSION_BUS_DECODING_1
#define RPD1_DIVMMC 0x01
#define RPD1_MULTIFACE 0x02
#define RPD1_I2C 0x04
#define RPD1_SPI 0x08
#define RPD1_UART 0x10
#define RPD1_MOUSE 0x20
#define RPD1_SPRITES 0x40
#define RPD1_LAYER_2 0x80

// Bits of REG_INTERNAL_PORT_DECODING_2 and REG_EXPANSION_BUS_DECODING_2
#define RPD2_AY 0x01
#define RPD2_DAC_SOUNDRIVE_1 0x02
#define RPD2_DAC_SOUNDRIVE_2 0x04
#define RPD2_DAC_STEREO_PROFI_COVOX 0x08
#define RPD2_DAC_STEREO_COVOX 0x10
#define RPD2_DAC_MONO_PENTAGON_ATM 0x20
#define RPD2_DAC_MONO_GS_COVOX 0x40
#define RPD2_DAC_MONO_SPECDRUM 0x80

// Bits of REG_INTERNAL_PORT_DECODING_3 and REG_EXPANSION_BUS_DECODING_3
#define RPD3_ULA_PLUS 0x01
#define RPD3_Z80_DMA 0x02
#define RPD3_PENTAGON_1024 0x04
#define RPD3_CTC 0x08

// Register reset mode: selects whether these registers are set on a soft or a hard reset
#define RPD3_REGISTER_RESET_MODE 0x80

// ------------------------------------------
// Expansion bus io propagate
// ------------------------------------------
// While the expansion bus is on the io cycles for the selected ports are also
// sent to the bus so external peripherals can follow the internal state. Values read
// from the bus on port 0xfe are mixed into keyboard reads

#define REG_EXPANSION_BUS_IO_PROPAGATE 0x8A

#define REBIP_PORT_EFF7 0x20
#define REBIP_PORT_FF 0x10
#define REBIP_PORT_1FFD 0x08
#define REBIP_PORT_DFFD 0x04
#define REBIP_PORT_7FFD 0x02
#define REBIP_PORT_FE 0x01
