// ------------------------------------------
// User register
// ------------------------------------------

// Unused storage available to the user
#define REG_USER_0 0x7F

// ------------------------------------------
// I/O traps (experimental)
// ------------------------------------------
// A trap generates a multiface nmi that is flagged in REG_RESET. Traps are not
// triggered by the dma or while the multiface or divmmc or an external nmi is active

#define REG_IO_TRAPS 0xD8

// Enable the +3 fdc traps on ports 0x2ffd and 0x3ffd
#define RIT_ENABLE_P3_FDC_TRAPS 0x01

// Byte written during the trapped i/o write cycle
#define REG_IO_TRAP_WRITE 0xD9

// Cause of the trap
#define REG_IO_TRAP_CAUSE 0xDA

#define RITC_NONE 0x00
#define RITC_PORT_2FFD_READ 0x01
#define RITC_PORT_3FFD_READ 0x02
#define RITC_PORT_3FFD_WRITE 0x03

// --------------------------------------------------------
// XDEV command (issues 4 and 5 only)
// --------------------------------------------------------
// Selects the Xilinx device attached to the register and then talks to it

#define REG_XDEV_COMMAND 0xF0

// Select mode: reads 1 in select mode. Write 1 to enter it or 0 to attach the selected device
#define RXC_SELECT_MODE 0x80

// Select mode: change the selected device (write together with RXC_SELECT_MODE)
#define RXC_CHANGE_DEVICE 0x40

// Select mode: device (bits 1:0)
#define RXC_DEVICE_MASK 0x03
#define RXC_DEVICE_NONE 0x00
#define RXC_DEVICE_DNA 0x01
#define RXC_DEVICE_XADC 0x02

// DNA mode: next dna bit. The first eight bits read give the length of the dna string
#define RXC_DNA_BIT 0x01

// XADC mode read: busy with a conversion (BUSY) and conversion done (EOC) and sequence done (EOS)
#define RXC_XADC_BUSY 0x40
#define RXC_XADC_EOC 0x02
#define RXC_XADC_EOS 0x01

// XADC mode write: reset the XADC (RESET) and start a conversion (CONVST)
#define RXC_XADC_RESET 0x40
#define RXC_XADC_CONVST 0x01

// --------------------------------------------------------
// XADC DRP access (issues 4 and 5 only)
// --------------------------------------------------------
// Writing REG_XADC_REGISTER starts the read or write. Leave at least six 28MHz
// cycles after each access

#define REG_XADC_REGISTER 0xF8

// Write to the XADC DRP port instead of reading from it (reads as 0)
#define RXR_WRITE 0x80

// DRP register address DADDR
#define RXR_ADDRESS_MASK 0x7F

// DRP data bus D7:0 and D15:8. Reads store the result here and writes take the value from here
#define REG_XADC_DATA_L 0xF9
#define REG_XADC_DATA_H 0xFA
