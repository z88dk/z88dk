





#ifndef __CONFIG_Z88DK_H_
#define __CONFIG_Z88DK_H_

// Automatically Generated at Library Build Time














#undef  __Z88DK
#define __Z88DK  2300












#undef  __RC2014
#define __RC2014  1

#define __IO_DIO_PORT  0x00
#define __IO_CF_8_BIT  0x01
#define __IO_CF_PORT_BASE  0x10
#define __IO_PIO_PORT_BASE  0x20












#undef  __8085
#define __8085  0x01

#define __CPU_INFO  0x00













#define __IO_ACIA_CONTROL_REGISTER    0x80
#define __IO_ACIA_STATUS_REGISTER  0x80
#define __IO_ACIA_DATA_REGISTER    0x81

#define __IO_ACIA_CR_CLK_DIV_01   0x00
#define __IO_ACIA_CR_CLK_DIV_16   0x01
#define __IO_ACIA_CR_CLK_DIV_64   0x02
#define __IO_ACIA_CR_RESET        0x03

#define __IO_ACIA_CR_7E2          0x00
#define __IO_ACIA_CR_7O2          0x04
#define __IO_ACIA_CR_7E1          0x08
#define __IO_ACIA_CR_7O1          0x0C
#define __IO_ACIA_CR_8N2          0x10
#define __IO_ACIA_CR_8N1          0x14
#define __IO_ACIA_CR_8E1          0x18
#define __IO_ACIA_CR_8O1          0x1C

#define __IO_ACIA_CR_TDI_RTS0     0x00
#define __IO_ACIA_CR_TEI_RTS0     0x20
#define __IO_ACIA_CR_TDI_RTS1     0x40
#define __IO_ACIA_CR_TDI_BRK      0x60
   
#define __IO_ACIA_CR_TEI_MASK     0x60

#define __IO_ACIA_CR_REI          0x80

#define __IO_ACIA_SR_RDRF         0x01
#define __IO_ACIA_SR_TDRE         0x02
#define __IO_ACIA_SR_DCD          0x04
#define __IO_ACIA_SR_CTS          0x08
#define __IO_ACIA_SR_FE           0x10
#define __IO_ACIA_SR_OVRN         0x20
#define __IO_ACIA_SR_PE           0x40
#define __IO_ACIA_SR_IRQ          0x80

#define __IO_ACIA_RX_SIZE      0x100
#define __IO_ACIA_RX_FULLISH   0xf0
#define __IO_ACIA_RX_EMPTYISH 0x08
#define __IO_ACIA_TX_SIZE      0x20












#define __IO_SIOA_CONTROL_REGISTER  0x80
#define __IO_SIOA_DATA_REGISTER     0x81
#define __IO_SIOB_CONTROL_REGISTER  0x82
#define __IO_SIOB_DATA_REGISTER     0x83

#define __IO_SIO_WR0_NULL     0x00

#define __IO_SIO_WR0_R0     0x00
#define __IO_SIO_WR0_R1     0x01
#define __IO_SIO_WR0_R2     0x02
#define __IO_SIO_WR0_R3     0x03
#define __IO_SIO_WR0_R4     0x04
#define __IO_SIO_WR0_R5     0x05
#define __IO_SIO_WR0_R6     0x06
#define __IO_SIO_WR0_R7     0x07

#define __IO_SIO_WR0_SDLC_ABORT     0x08
#define __IO_SIO_WR0_EXT_INT_RESET     0x10
#define __IO_SIO_WR0_CHANNEL_RESET     0x18
#define __IO_SIO_WR0_RX_INT_FIRST_REENABLE     0x20
#define __IO_SIO_WR0_TX_INT_PENDING_RESET     0x28
#define __IO_SIO_WR0_ERROR_RESET     0x30
#define __IO_SIO_WR0_A_INT_RETURN     0x38

#define __IO_SIO_WR0_RX_CRC_RESET     0x40
#define __IO_SIO_WR0_TX_CRC_RESET     0x80
#define __IO_SIO_WR0_TX_EOM_RESET     0xC0

#define __IO_SIO_WR1_EXT_INT_ENABLE     0x01
#define __IO_SIO_WR1_TX_INT_ENABLE     0x02
#define __IO_SIO_WR1_B_STATUS_VECTOR     0x04

#define __IO_SIO_WR1_RX_INT_NONE     0x00
#define __IO_SIO_WR1_RX_INT_FIRST     0x08
#define __IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL     0x10
#define __IO_SIO_WR1_RX_INT_ALL     0x18

#define __IO_SIO_WR1_WAIT_READY_RX     0x20
#define __IO_SIO_WR1_WAIT_READY_READY     0x40
#define __IO_SIO_WR1_WAIT_READY_ENABLE     0x80

#define __IO_SIO_WR3_RX_ENABLE     0x01
#define __IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT     0x02
#define __IO_SIO_WR3_SDLC_ADDRESS_SEARCH     0x04
#define __IO_SIO_WR3_SDLC_RX_CRC     0x08
#define __IO_SIO_WR3_HUNT_PHASE_ENABLE     0x10
#define __IO_SIO_WR3_AUTO_ENABLES     0x20

#define __IO_SIO_WR3_RX_5BIT     0x00
#define __IO_SIO_WR3_RX_7BIT     0x40
#define __IO_SIO_WR3_RX_6BIT     0x80
#define __IO_SIO_WR3_RX_8BIT     0xC0

#define __IO_SIO_WR4_PARITY_NONE     0x00
#define __IO_SIO_WR4_PARITY_ENABLE     0x01
#define __IO_SIO_WR4_PARITY_EVEN     0x02

#define __IO_SIO_WR4_SYNC_MODE     0x00
#define __IO_SIO_WR4_STOP_1     0x04
#define __IO_SIO_WR4_STOP_3HALF     0x08
#define __IO_SIO_WR4_STOP_2     0x0C

#define __IO_SIO_WR4_SYNC_8BIT     0x00
#define __IO_SIO_WR4_SYNC_16BIT     0x10
#define __IO_SIO_WR4_SYNC_SDLC     0x20
#define __IO_SIO_WR4_SYNC_EXTERN     0x30

#define __IO_SIO_WR4_CLK_DIV_01     0x00
#define __IO_SIO_WR4_CLK_DIV_16     0x40
#define __IO_SIO_WR4_CLK_DIV_32     0x80
#define __IO_SIO_WR4_CLK_DIV_64     0xC0

#define __IO_SIO_WR5_TX_CRC_ENABLE     0x01
#define __IO_SIO_WR5_RTS     0x02
#define __IO_SIO_WR5_SDLC_CRC_16     0x04
#define __IO_SIO_WR5_TX_ENABLE     0x08
#define __IO_SIO_WR5_TX_BREAK     0x10

#define __IO_SIO_WR5_TX_5BIT     0x00
#define __IO_SIO_WR5_TX_7BIT     0x20
#define __IO_SIO_WR5_TX_6BIT     0x40
#define __IO_SIO_WR5_TX_8BIT     0x60

#define __IO_SIO_WR5_TX_DTR     0x80

#define __IO_SIO_RR0_RX_CHAR     0x01
#define __IO_SIO_RR0_A_INT_PENDING     0x02
#define __IO_SIO_RR0_TX_EMPTY     0x04
#define __IO_SIO_RR0_DCD     0x08
#define __IO_SIO_RR0_SYNC     0x10
#define __IO_SIO_RR0_CTS     0x20
#define __IO_SIO_RR0_TX_EOM     0x40
#define __IO_SIO_RR0_RX_BREAK     0x80

#define __IO_SIO_RR1_TX_ALL_SENT     0x01

#define __IO_SIO_RR1_SDLC_RESIDUE_CODE_0     0x02
#define __IO_SIO_RR1_SDLC_RESIDUE_CODE_1     0x04
#define __IO_SIO_RR1_SDLC_RESIDUE_CODE_2     0x08

#define __IO_SIO_RR1_RX_PARITY_ERROR     0x10
#define __IO_SIO_RR1_RX_OVERRUN     0x20
#define __IO_SIO_RR1_RX_FRAMING_ERROR     0x40
#define __IO_SIO_RR1_SDLC_EOF     0x80

#define __IO_SIO_RX_SIZE        0x80
#define __IO_SIO_RX_FULLISH     0x70
#define __IO_SIO_RX_EMPTYISH    0x08
#define __IO_SIO_TX_SIZE        0x10












#define __IO_UARTA_DATA_REGISTER    0x80
#define __IO_UARTA_IER_REGISTER     0x81
#define __IO_UARTA_IIR_REGISTER     0x82
#define __IO_UARTA_FCR_REGISTER     0x82
#define __IO_UARTA_LCR_REGISTER     0x83
#define __IO_UARTA_MCR_REGISTER     0x84
#define __IO_UARTA_LSR_REGISTER     0x85
#define __IO_UARTA_MSR_REGISTER     0x86
#define __IO_UARTA_SCRATCH_REGISTER 0x87

#define __IO_UARTA_DLL_REGISTER     0x80
#define __IO_UARTA_DLM_REGISTER     0x81

#define __IO_UARTB_DATA_REGISTER    0x88
#define __IO_UARTB_IER_REGISTER     0x89
#define __IO_UARTB_IIR_REGISTER     0x8a
#define __IO_UARTB_FCR_REGISTER     0x8a
#define __IO_UARTB_LCR_REGISTER     0x8b
#define __IO_UARTB_MCR_REGISTER     0x8c
#define __IO_UARTB_LSR_REGISTER     0x8d
#define __IO_UARTB_MSR_REGISTER     0x8e
#define __IO_UARTB_SCRATCH_REGISTER 0x8f

#define __IO_UARTB_DLL_REGISTER     0x88
#define __IO_UARTB_DLM_REGISTER     0x89

#define __IO_UART_IER_ERBI          0x01
#define __IO_UART_IER_ETBEI         0x02
#define __IO_UART_IER_ETSI          0x04
#define __IO_UART_IER_EDSSI         0x08

#define __IO_UART_IIR_PENDING       0x01
#define __IO_UART_IIR_ID_1          0x02
#define __IO_UART_IIR_ID_2          0x04
#define __IO_UART_IIR_ID_3          0x08
#define __IO_UART_IIR_FIFO_LSB      0x40
#define __IO_UART_IIR_FIFO_MSB      0x80

#define __IO_UART_IIR_THRE          0x02
#define __IO_UART_IIR_DATA          0x04
#define __IO_UART_IIR_RLS           0x06
#define __IO_UART_IIR_TIMEOUT       0x0C
#define __IO_UART_IIR_MASK          0x0E

#define __IO_UART_FCR_FIFO_ENABLE       0x01
#define __IO_UART_FCR_FIFO_RX_RESET     0x02
#define __IO_UART_FCR_FIFO_TX_RESET     0x04
#define __IO_UART_FCR_DMA_MODE_SELECT   0x08
#define __IO_UART_FCR_RECEIVER_LSB      0x40
#define __IO_UART_FCR_RECEIVER_MSB      0x80

#define __IO_UART_FCR_FIFO_01      0x00
#define __IO_UART_FCR_FIFO_04      0x40
#define __IO_UART_FCR_FIFO_08      0x80
#define __IO_UART_FCR_FIFO_14      0xC0

#define __IO_UART_LCR_5BIT      0x00
#define __IO_UART_LCR_6BIT      0x01
#define __IO_UART_LCR_7BIT      0x02
#define __IO_UART_LCR_8BIT      0x03

#define __IO_UART_LCR_STOP          0x04
#define __IO_UART_LCR_PARITY_ENABLE 0x08
#define __IO_UART_LCR_PARITY_EVEN   0x10
#define __IO_UART_LCR_PARITY_STICK  0x20
#define __IO_UART_LCR_BREAK_CONTROL 0x40
#define __IO_UART_LCR_DLAB          0x80

#define __IO_UART_MCR_DTR               0x01
#define __IO_UART_MCR_RTS               0x02
#define __IO_UART_MCR_OUTPUT1           0x04
#define __IO_UART_MCR_INT_ENABLE        0x08
#define __IO_UART_MCR_LOOPBACK          0x10
#define __IO_UART_MCR_AUTO_FLOW_CONTROL 0x20

#define __IO_UART_LSR_DATA_READY        0x01
#define __IO_UART_LSR_OVERRUN_ERROR     0x02
#define __IO_UART_LSR_PARITY_ERROR      0x04
#define __IO_UART_LSR_FRAMING_ERROR     0x08
#define __IO_UART_LSR_BREAK_INTERRUPT   0x10
#define __IO_UART_LSR_TX_HOLDING_THRE   0x20
#define __IO_UART_LSR_TX_EMPTY_TEMT     0x40
#define __IO_UART_LSR_RX_FIFO_ERROR     0x80

#define __IO_UART_MSR_CTS_DELTA         0x01
#define __IO_UART_MSR_DSR_DELTA         0x02
#define __IO_UART_MSR_TERI              0x04
#define __IO_UART_MSR_DCD_DELTA         0x08
#define __IO_UART_MSR_CTS               0x10
#define __IO_UART_MSR_DSR               0x20
#define __IO_UART_MSR_RING_INDICATOR    0x40
#define __IO_UART_MSR_DCD               0x80

#define __IO_UART_RX_SIZE        0x80
#define __IO_UART_RX_FULLISH     0x70
#define __IO_UART_RX_EMPTYISH    0x08

#define __IO_UART_DLL_115200     0x01
#define __IO_UART_DLL_57600      0x02
#define __IO_UART_DLL_38400      0x03
#define __IO_UART_DLL_19200      0x06
#define __IO_UART_DLL_9600       0x0C
#define __IO_UART_DLL_2400       0x30












#define __IO_PIO_PORT_A  0x20
#define __IO_PIO_PORT_B  0x21
#define __IO_PIO_PORT_C  0x22
#define __IO_PIO_CONTROL  0x23

#define __IO_PIO_CNTL_00  0x80
#define __IO_PIO_CNTL_01  0x81
#define __IO_PIO_CNTL_02  0x82
#define __IO_PIO_CNTL_03  0x83

#define __IO_PIO_CNTL_04  0x88
#define __IO_PIO_CNTL_05  0x89
#define __IO_PIO_CNTL_06  0x8A
#define __IO_PIO_CNTL_07  0x8B

#define __IO_PIO_CNTL_08  0x90
#define __IO_PIO_CNTL_09  0x91
#define __IO_PIO_CNTL_10  0x92
#define __IO_PIO_CNTL_11  0x83

#define __IO_PIO_CNTL_12  0x98
#define __IO_PIO_CNTL_13  0x99
#define __IO_PIO_CNTL_14  0x9A
#define __IO_PIO_CNTL_15  0x9B












#define __IO_CF_IDE_DATA  0x10
#define __IO_CF_IDE_ERROR  0x11
#define __IO_CF_IDE_FEATURE  0x11
#define __IO_CF_IDE_SEC_CNT  0x12
#define __IO_CF_IDE_SECTOR  0x13
#define __IO_CF_IDE_CYL_LSB  0x14
#define __IO_CF_IDE_CYL_MSB  0x15
#define __IO_CF_IDE_HEAD  0x16
#define __IO_CF_IDE_COMMAND  0x17
#define __IO_CF_IDE_STATUS  0x17

#define __IO_CF_IDE_CONTROL  0x1e
#define __IO_CF_IDE_ALT_STATUS  0x1e

#define __IO_CF_IDE_LBA0  0x13
#define __IO_CF_IDE_LBA1  0x14
#define __IO_CF_IDE_LBA2  0x15
#define __IO_CF_IDE_LBA3  0x16













#define __IO_PIO_IDE_LSB  0x20
#define __IO_PIO_IDE_MSB  0x21
#define __IO_PIO_IDE_CTL  0x22
#define __IO_PIO_IDE_CONFIG  0x23
#define __IO_PIO_IDE_RD  0x92
#define __IO_PIO_IDE_WR  0x80

#define __IO_PIO_IDE_A0_LINE  0x01
#define __IO_PIO_IDE_A1_LINE  0x02
#define __IO_PIO_IDE_A2_LINE  0x04
#define __IO_PIO_IDE_CS0_LINE  0x08
#define __IO_PIO_IDE_CS1_LINE  0x10
#define __IO_PIO_IDE_WR_LINE  0x20
#define __IO_PIO_IDE_RD_LINE  0x40
#define __IO_PIO_IDE_RST_LINE  0x80

#define __IO_PIO_IDE_DATA  0x08
#define __IO_PIO_IDE_ERROR  0x9
#define __IO_PIO_IDE_FEATURE  0x9
#define __IO_PIO_IDE_SEC_CNT  0xa
#define __IO_PIO_IDE_SECTOR  0xb
#define __IO_PIO_IDE_CYL_LSB  0xc
#define __IO_PIO_IDE_CYL_MSB  0xd
#define __IO_PIO_IDE_HEAD  0xe
#define __IO_PIO_IDE_COMMAND  0xf
#define __IO_PIO_IDE_STATUS  0xf

#define __IO_PIO_IDE_CONTROL  0x16
#define __IO_PIO_IDE_ALT_STATUS  0x16

#define __IO_PIO_IDE_LBA0  0xb
#define __IO_PIO_IDE_LBA1  0xc
#define __IO_PIO_IDE_LBA2  0xd
#define __IO_PIO_IDE_LBA3  0xe

#define __IDE_CMD_READ  0x20
#define __IDE_CMD_WRITE  0x30

#define __IDE_CMD_STANDBY  0xE0
#define __IDE_CMD_IDLE  0xE1
#define __IDE_CMD_SLEEP  0xE6
#define __IDE_CMD_CACHE_FLUSH  0xE7
#define __IDE_CMD_ID  0xEC
#define __IDE_CMD_FEATURE  0xEF













#define __IO_RAM_TOGGLE  0x30
#define __IO_ROM_TOGGLE  0x38
#define __IO_RAM_SHADOW_BASE  0x58

#define __IO_RAM_SHADOW_AVAILABLE  0x00













#define __CPM_RCON  1
#define __CPM_WCON  2
#define __CPM_RRDR  3
#define __CPM_WPUN  4
#define __CPM_WLST  5
#define __CPM_DCIO  6
#define __CPM_GIOB  7
#define __CPM_SIOB  8
#define __CPM_PRST  9
#define __CPM_RCOB  10
#define __CPM_ICON  11
#define __CPM_VERS  12
#define __CPM_RDS   13
#define __CPM_LGIN  14
#define __CPM_OPN   15
#define __CPM_CLS   16
#define __CPM_FFST  17
#define __CPM_FNXT  18
#define __CPM_DEL   19
#define __CPM_READ  20
#define __CPM_WRIT  21
#define __CPM_MAKE  22
#define __CPM_REN   23
#define __CPM_ILOG  24
#define __CPM_IDRV  25
#define __CPM_SDMA  26
#define __CPM_SUID  32
#define __CPM_RRAN  33
#define __CPM_WRAN  34
#define __CPM_CFS   35
#define __CPM_DSEG  51





#endif



