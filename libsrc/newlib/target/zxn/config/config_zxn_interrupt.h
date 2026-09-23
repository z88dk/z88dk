// --------------------------------------------------------
// Interrupt control status and enable registers
// --------------------------------------------------------

// Selects the maskable interrupt mode and the programmable im2 vector
#define REG_INTERRUPT_CONTROL 0xC0

// Programmable portion of the im2 vector occupies the three high bits
#define RIC_IM2_VECTOR_MASK 0xE0

// Enable stackless nmi response
#define RIC_ENABLE_STACKLESS_NMI 0x08

// Current Z80 interrupt mode (read only) in bits 2:1
#define RIC_Z80_INTERRUPT_MODE_MASK 0x06

// Maskable interrupt mode: pulse (0) or hardware im2 (1)
#define RIC_MODE_PULSE 0x00
#define RIC_MODE_HW_IM2 0x01

// --------------------------------------------------------
// Interrupt enable registers
// --------------------------------------------------------
// A disabled device interrupt enters a polled mode

#define REG_INTERRUPT_ENABLE_0 0xC4
#define REG_INTERRUPT_ENABLE_1 0xC5
#define REG_INTERRUPT_ENABLE_2 0xC6

// --------------------------------------------------------
// Interrupt status registers
// --------------------------------------------------------
// Reading a set bit means the device generated an interrupt or one is pending
// Writing a set bit clears that status

#define REG_INTERRUPT_STATUS_0 0xC8
#define REG_INTERRUPT_STATUS_1 0xC9
#define REG_INTERRUPT_STATUS_2 0xCA

// --------------------------------------------------------
// DMA interrupt enable registers
// --------------------------------------------------------
// A set bit means the interrupt will interrupt a dma operation in hardware im2 mode

#define REG_DMA_INTERRUPT_ENABLE_0 0xCC
#define REG_DMA_INTERRUPT_ENABLE_1 0xCD
#define REG_DMA_INTERRUPT_ENABLE_2 0xCE

// --------------------------------------------------------
// Bits shared by the group 0 registers above
// --------------------------------------------------------
// Bit 7 is the expansion bus /INT in REG_INTERRUPT_ENABLE_0 and the NMI in
// REG_DMA_INTERRUPT_ENABLE_0. It is reserved in REG_INTERRUPT_STATUS_0

#define RI0_EXPANSION_BUS 0x80
#define RI0_NMI 0x80
#define RI0_LINE 0x02
#define RI0_ULA 0x01

// --------------------------------------------------------
// Bits shared by the group 1 registers above (CTC channels)
// --------------------------------------------------------

#define RI1_CTC_CHANNEL_0 0x01
#define RI1_CTC_CHANNEL_1 0x02
#define RI1_CTC_CHANNEL_2 0x04
#define RI1_CTC_CHANNEL_3 0x08
#define RI1_CTC_CHANNEL_4 0x10
#define RI1_CTC_CHANNEL_5 0x20
#define RI1_CTC_CHANNEL_6 0x40
#define RI1_CTC_CHANNEL_7 0x80

// --------------------------------------------------------
// Bits shared by the group 2 registers above (UART)
// --------------------------------------------------------
// The Rx available and Rx near full sources share one interrupt and
// Rx near full overrides Rx available

#define RI2_UART0_RX_AVAILABLE 0x01
#define RI2_UART0_RX_NEAR_FULL 0x02
#define RI2_UART0_TX_EMPTY 0x04
#define RI2_UART1_RX_AVAILABLE 0x10
#define RI2_UART1_RX_NEAR_FULL 0x20
#define RI2_UART1_TX_EMPTY 0x40

// --------------------------------------------------------
// Vertical line count offset
// --------------------------------------------------------

// Offset added to the vertical line counter. It affects the copper the line
// interrupt and the active line count. A change takes up to one frame to occur
#define REG_LINE_INTERRUPT_OFFSET 0x64
