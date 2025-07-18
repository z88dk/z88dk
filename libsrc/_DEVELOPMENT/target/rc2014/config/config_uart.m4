divert(-1)

###############################################################
# 16550 UART CONFIGURATION
# rebuild the library if changes are made
#

define(`__IO_UARTA_DATA_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+00,16))    # Channel A Tx / Rx Data Register
define(`__IO_UARTA_IER_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+01,16))     # Channel A Interrupt Enable Register
define(`__IO_UARTA_IIR_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+02,16))     # Channel A Interrupt Identification Register
define(`__IO_UARTA_FCR_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+02,16))     # Channel A FIFO Control Register
define(`__IO_UARTA_LCR_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+03,16))     # Channel A Line Control Register
define(`__IO_UARTA_MCR_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+04,16))     # Channel A MODEM Control Register
define(`__IO_UARTA_LSR_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+05,16))     # Channel A Line Status Register
define(`__IO_UARTA_MSR_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+06,16))     # Channel A MODEM Status Register
define(`__IO_UARTA_SCRATCH_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+07,16)) # Channel A Scratch Register

define(`__IO_UARTA_DLL_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+00,16))     # Channel A Divisor Latch LSB (DLAB 1)
define(`__IO_UARTA_DLM_REGISTER', 0x`'eval(__IO_UART_PORTA_BASE+01,16))     # Channel A Divisor Latch MSB (DLAB 1)

define(`__IO_UARTB_DATA_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+00,16))    # Channel B Tx / Rx Data Register
define(`__IO_UARTB_IER_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+01,16))     # Channel B Interrupt Enable Register
define(`__IO_UARTB_IIR_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+02,16))     # Channel B Interrupt Identification Register
define(`__IO_UARTB_FCR_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+02,16))     # Channel B FIFO Control Register
define(`__IO_UARTB_LCR_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+03,16))     # Channel B Line Control Register
define(`__IO_UARTB_MCR_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+04,16))     # Channel B MODEM Control Register
define(`__IO_UARTB_LSR_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+05,16))     # Channel B Line Status Register
define(`__IO_UARTB_MSR_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+06,16))     # Channel B MODEM Status Register
define(`__IO_UARTB_SCRATCH_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+07,16)) # Channel B Scratch Register

define(`__IO_UARTB_DLL_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+00,16))   # Channel A Divisor Latch LSB (DLAB 1)
define(`__IO_UARTB_DLM_REGISTER', 0x`'eval(__IO_UART_PORTB_BASE+01,16))   # Channel A Divisor Latch MSB (DLAB 1)

# Write Register 1 - Interrupt Enable Register

define(`__IO_UART_IER_ERBI', 0x01)          # Enable Received Data
define(`__IO_UART_IER_ETBEI', 0x02)         # Enable Transmitter Holding Register Empty
define(`__IO_UART_IER_ETSI', 0x04)          # Enable Receiver Line Status
define(`__IO_UART_IER_EDSSI', 0x08)         # Enable MODEM Status

# Read Register 2 - Interrupt Identity Register

define(`__IO_UART_IIR_PENDING', 0x01)       # 0 if Interrupt Pending
define(`__IO_UART_IIR_ID_1', 0x02)          # Interrupt ID 1
define(`__IO_UART_IIR_ID_2', 0x04)          # Interrupt ID 2
define(`__IO_UART_IIR_ID_3', 0x08)          # Interrupt ID 3
define(`__IO_UART_IIR_FIFO_LSB', 0x40)      # FIFO LSB
define(`__IO_UART_IIR_FIFO_MSB', 0x80)      # FIFO MSB

define(`__IO_UART_IIR_THRE', 0x02)          # Interrupt THR Empty
define(`__IO_UART_IIR_DATA', 0x04)          # Interrupt Rx Data Available
define(`__IO_UART_IIR_RLS', 0x06)           # Interrupt Rx Line Status
define(`__IO_UART_IIR_TIMEOUT', 0x0C)       # Interrupt RX Data Timeout
define(`__IO_UART_IIR_MASK', 0x0E)          # Interrupt mask

# Write Register 2 - FIFO Control Register

define(`__IO_UART_FCR_FIFO_ENABLE', 0x01)       # FIFO Enabled (Set for Programming)
define(`__IO_UART_FCR_FIFO_RX_RESET', 0x02)     # Receiver FIFO Reset
define(`__IO_UART_FCR_FIFO_TX_RESET', 0x04)     # Transmitter FIFO Reset
define(`__IO_UART_FCR_DMA_MODE_SELECT', 0x08)   # DMA Mode Select
define(`__IO_UART_FCR_RECEIVER_LSB', 0x40)      # Receiver FIFO Trigger LSB
define(`__IO_UART_FCR_RECEIVER_MSB', 0x80)      # Receiver FIFO Trigger MSB

define(`__IO_UART_FCR_FIFO_01', 0x00)       # FIFO Trigger 01 Bytes
define(`__IO_UART_FCR_FIFO_04', 0x40)       # FIFO Trigger 04 Bytes
define(`__IO_UART_FCR_FIFO_08', 0x80)       # FIFO Trigger 08 Bytes
define(`__IO_UART_FCR_FIFO_14', 0xC0)       # FIFO Trigger 14 Bytes

# Write Register 3 - Line Control Register

define(`__IO_UART_LCR_5BIT', 0x00)
define(`__IO_UART_LCR_6BIT', 0x01)
define(`__IO_UART_LCR_7BIT', 0x02)
define(`__IO_UART_LCR_8BIT', 0x03)
define(`__IO_UART_LCR_STOP', 0x04)
define(`__IO_UART_LCR_PARITY_ENABLE', 0x08)
define(`__IO_UART_LCR_PARITY_EVEN', 0x10)
define(`__IO_UART_LCR_PARITY_STICK', 0x20)
define(`__IO_UART_LCR_BREAK_CONTROL', 0x40)
define(`__IO_UART_LCR_DLAB', 0x80)              # Divisor Latch Access Bit DLAB

# Write Register 4 - MODEM Control Register

define(`__IO_UART_MCR_DTR', 0x01)
define(`__IO_UART_MCR_RTS', 0x02)
define(`__IO_UART_MCR_OUTPUT1', 0x04)
define(`__IO_UART_MCR_INT_ENABLE', 0x08)        # Global Interrupt Enable
define(`__IO_UART_MCR_LOOPBACK', 0x10)          # Loopback Test
define(`__IO_UART_MCR_AUTO_FLOW_CONTROL', 0x20) # Auto Flow Control Enable AFE

# Read Register 5 - Line Status Register

define(`__IO_UART_LSR_DATA_READY', 0x01)
define(`__IO_UART_LSR_OVERRUN_ERROR', 0x02)
define(`__IO_UART_LSR_PARITY_ERROR', 0x04)
define(`__IO_UART_LSR_FRAMING_ERROR', 0x08)
define(`__IO_UART_LSR_BREAK_INTERRUPT', 0x10)
define(`__IO_UART_LSR_TX_HOLDING_THRE', 0x20)
define(`__IO_UART_LSR_TX_EMPTY_TEMT', 0x40)
define(`__IO_UART_LSR_RX_FIFO_ERROR', 0x80)

# Read Register 6 - MODEM Status Register

define(`__IO_UART_MSR_CTS_DELTA', 0x01)
define(`__IO_UART_MSR_DSR_DELTA', 0x02)
define(`__IO_UART_MSR_TERI', 0x04)
define(`__IO_UART_MSR_DCD_DELTA', 0x08)
define(`__IO_UART_MSR_CTS', 0x10)
define(`__IO_UART_MSR_DSR', 0x20)
define(`__IO_UART_MSR_RING_INDICATOR', 0x40)
define(`__IO_UART_MSR_DCD', 0x80)

# 16550 UART driver

define(`__IO_UART_RX_SIZE', 0x80)       # Size of the Rx Buffer (greater than 0x20)
define(`__IO_UART_RX_FULLISH', 0x`'eval(__IO_UART_RX_SIZE-24,16))
                                        # Fullness of the Rx Buffer, when NOT_RTS is signalled
define(`__IO_UART_RX_EMPTYISH', 0x08)   # Fullness of the Rx Buffer, when RTS is signalled

define(`__IO_UART_DLL_115200', 0x01)    # Divisor Latch LSB for 115,200 baud
define(`__IO_UART_DLL_57600', 0x02)     # Divisor Latch LSB for 57,600 baud
define(`__IO_UART_DLL_38400', 0x03)     # Divisor Latch LSB for 38,400 baud
define(`__IO_UART_DLL_19200', 0x06)     # Divisor Latch LSB for 19,200 baud
define(`__IO_UART_DLL_9600', 0x0C)      # Divisor Latch LSB for 9,600 baud
define(`__IO_UART_DLL_2400', 0x30)      # Divisor Latch LSB for 2,400 baud

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_UARTA_DATA_REGISTER'
PUBLIC `__IO_UARTA_IER_REGISTER'
PUBLIC `__IO_UARTA_IIR_REGISTER'
PUBLIC `__IO_UARTA_FCR_REGISTER'
PUBLIC `__IO_UARTA_LCR_REGISTER'
PUBLIC `__IO_UARTA_MCR_REGISTER'
PUBLIC `__IO_UARTA_LSR_REGISTER'
PUBLIC `__IO_UARTA_MSR_REGISTER'
PUBLIC `__IO_UARTA_SCRATCH_REGISTER'

PUBLIC `__IO_UARTA_DLL_REGISTER'
PUBLIC `__IO_UARTA_DLM_REGISTER'

PUBLIC `__IO_UARTB_DATA_REGISTER'
PUBLIC `__IO_UARTB_IER_REGISTER'
PUBLIC `__IO_UARTB_IIR_REGISTER'
PUBLIC `__IO_UARTB_FCR_REGISTER'
PUBLIC `__IO_UARTB_LCR_REGISTER'
PUBLIC `__IO_UARTB_MCR_REGISTER'
PUBLIC `__IO_UARTB_LSR_REGISTER'
PUBLIC `__IO_UARTB_MSR_REGISTER'
PUBLIC `__IO_UARTB_SCRATCH_REGISTER'

PUBLIC `__IO_UARTB_DLL_REGISTER'
PUBLIC `__IO_UARTB_DLM_REGISTER'

PUBLIC `__IO_UART_IER_ERBI'
PUBLIC `__IO_UART_IER_ETBEI'
PUBLIC `__IO_UART_IER_ETSI'
PUBLIC `__IO_UART_IER_EDSSI'

PUBLIC `__IO_UART_IIR_PENDING'
PUBLIC `__IO_UART_IIR_ID_1'
PUBLIC `__IO_UART_IIR_ID_2'
PUBLIC `__IO_UART_IIR_ID_3'
PUBLIC `__IO_UART_IIR_FIFO_LSB'
PUBLIC `__IO_UART_IIR_FIFO_MSB'

PUBLIC `__IO_UART_IIR_THRE'
PUBLIC `__IO_UART_IIR_DATA'
PUBLIC `__IO_UART_IIR_RLS'
PUBLIC `__IO_UART_IIR_TIMEOUT'
PUBLIC `__IO_UART_IIR_MASK'

PUBLIC `__IO_UART_FCR_FIFO_ENABLE'
PUBLIC `__IO_UART_FCR_FIFO_RX_RESET'
PUBLIC `__IO_UART_FCR_FIFO_TX_RESET'
PUBLIC `__IO_UART_FCR_DMA_MODE_SELECT'
PUBLIC `__IO_UART_FCR_RECEIVER_LSB'
PUBLIC `__IO_UART_FCR_RECEIVER_MSB'

PUBLIC `__IO_UART_FCR_FIFO_01'
PUBLIC `__IO_UART_FCR_FIFO_04'
PUBLIC `__IO_UART_FCR_FIFO_08'
PUBLIC `__IO_UART_FCR_FIFO_14'

PUBLIC `__IO_UART_LCR_5BIT'
PUBLIC `__IO_UART_LCR_6BIT'
PUBLIC `__IO_UART_LCR_7BIT'
PUBLIC `__IO_UART_LCR_8BIT'
PUBLIC `__IO_UART_LCR_STOP'
PUBLIC `__IO_UART_LCR_PARITY_ENABLE'
PUBLIC `__IO_UART_LCR_PARITY_EVEN'
PUBLIC `__IO_UART_LCR_PARITY_STICK'
PUBLIC `__IO_UART_LCR_BREAK_CONTROL'
PUBLIC `__IO_UART_LCR_DLAB'

PUBLIC `__IO_UART_MCR_DTR'
PUBLIC `__IO_UART_MCR_RTS'
PUBLIC `__IO_UART_MCR_OUTPUT1'
PUBLIC `__IO_UART_MCR_INT_ENABLE'
PUBLIC `__IO_UART_MCR_LOOPBACK'
PUBLIC `__IO_UART_MCR_AUTO_FLOW_CONTROL'

PUBLIC `__IO_UART_LSR_DATA_READY'
PUBLIC `__IO_UART_LSR_OVERRUN_ERROR'
PUBLIC `__IO_UART_LSR_PARITY_ERROR'
PUBLIC `__IO_UART_LSR_FRAMING_ERROR'
PUBLIC `__IO_UART_LSR_BREAK_INTERRUPT'
PUBLIC `__IO_UART_LSR_TX_HOLDING_THRE'
PUBLIC `__IO_UART_LSR_TX_EMPTY_TEMT'
PUBLIC `__IO_UART_LSR_RX_FIFO_ERROR'

PUBLIC `__IO_UART_MSR_CTS_DELTA'
PUBLIC `__IO_UART_MSR_DSR_DELTA'
PUBLIC `__IO_UART_MSR_TERI'
PUBLIC `__IO_UART_MSR_DCD_DELTA'
PUBLIC `__IO_UART_MSR_CTS'
PUBLIC `__IO_UART_MSR_DSR'
PUBLIC `__IO_UART_MSR_RING_INDICATOR'
PUBLIC `__IO_UART_MSR_DCD'

PUBLIC `__IO_UART_RX_SIZE'
PUBLIC `__IO_UART_RX_FULLISH'
PUBLIC `__IO_UART_RX_EMPTYISH'

PUBLIC `__IO_UART_DLL_115200'
PUBLIC `__IO_UART_DLL_57600'
PUBLIC `__IO_UART_DLL_38400'
PUBLIC `__IO_UART_DLL_19200'
PUBLIC `__IO_UART_DLL_9600'
PUBLIC `__IO_UART_DLL_2400'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_UARTA_DATA_REGISTER'     = __IO_UARTA_DATA_REGISTER
defc `__IO_UARTA_IER_REGISTER'      = __IO_UARTA_IER_REGISTER
defc `__IO_UARTA_IIR_REGISTER'      = __IO_UARTA_IIR_REGISTER
defc `__IO_UARTA_FCR_REGISTER'      = __IO_UARTA_FCR_REGISTER
defc `__IO_UARTA_LCR_REGISTER'      = __IO_UARTA_LCR_REGISTER
defc `__IO_UARTA_MCR_REGISTER'      = __IO_UARTA_MCR_REGISTER
defc `__IO_UARTA_LSR_REGISTER'      = __IO_UARTA_LSR_REGISTER
defc `__IO_UARTA_MSR_REGISTER'      = __IO_UARTA_MSR_REGISTER
defc `__IO_UARTA_SCRATCH_REGISTER'  = __IO_UARTA_SCRATCH_REGISTER

defc `__IO_UARTA_DLL_REGISTER'      = __IO_UARTA_DLL_REGISTER
defc `__IO_UARTA_DLM_REGISTER'      = __IO_UARTA_DLM_REGISTER

defc `__IO_UARTB_DATA_REGISTER'     = __IO_UARTB_DATA_REGISTER
defc `__IO_UARTB_IER_REGISTER'      = __IO_UARTB_IER_REGISTER
defc `__IO_UARTB_IIR_REGISTER'      = __IO_UARTB_IIR_REGISTER
defc `__IO_UARTB_FCR_REGISTER'      = __IO_UARTB_FCR_REGISTER
defc `__IO_UARTB_LCR_REGISTER'      = __IO_UARTB_LCR_REGISTER
defc `__IO_UARTB_MCR_REGISTER'      = __IO_UARTB_MCR_REGISTER
defc `__IO_UARTB_LSR_REGISTER'      = __IO_UARTB_LSR_REGISTER
defc `__IO_UARTB_MSR_REGISTER'      = __IO_UARTB_MSR_REGISTER
defc `__IO_UARTB_SCRATCH_REGISTER'  = __IO_UARTB_SCRATCH_REGISTER

defc `__IO_UARTB_DLL_REGISTER'      = __IO_UARTB_DLL_REGISTER
defc `__IO_UARTB_DLM_REGISTER'      = __IO_UARTB_DLM_REGISTER

defc `__IO_UART_IER_ERBI'           = __IO_UART_IER_ERBI
defc `__IO_UART_IER_ETBEI'          = __IO_UART_IER_ETBEI
defc `__IO_UART_IER_ETSI'           = __IO_UART_IER_ETSI
defc `__IO_UART_IER_EDSSI'          = __IO_UART_IER_EDSSI

defc `__IO_UART_IIR_PENDING'        = __IO_UART_IIR_PENDING
defc `__IO_UART_IIR_ID_1'           = __IO_UART_IIR_ID_1
defc `__IO_UART_IIR_ID_2'           = __IO_UART_IIR_ID_2
defc `__IO_UART_IIR_ID_3'           = __IO_UART_IIR_ID_3
defc `__IO_UART_IIR_FIFO_LSB'       = __IO_UART_IIR_FIFO_LSB
defc `__IO_UART_IIR_FIFO_MSB'       = __IO_UART_IIR_FIFO_MSB

defc `__IO_UART_IIR_THRE'           = __IO_UART_IIR_THRE
defc `__IO_UART_IIR_DATA'           = __IO_UART_IIR_DATA
defc `__IO_UART_IIR_RLS'            = __IO_UART_IIR_RLS
defc `__IO_UART_IIR_TIMEOUT'        = __IO_UART_IIR_TIMEOUT
defc `__IO_UART_IIR_MASK'           = __IO_UART_IIR_MASK

defc `__IO_UART_FCR_FIFO_ENABLE'        = __IO_UART_FCR_FIFO_ENABLE
defc `__IO_UART_FCR_FIFO_RX_RESET'      = __IO_UART_FCR_FIFO_RX_RESET
defc `__IO_UART_FCR_FIFO_TX_RESET'      = __IO_UART_FCR_FIFO_TX_RESET
defc `__IO_UART_FCR_DMA_MODE_SELECT'    = __IO_UART_FCR_DMA_MODE_SELECT
defc `__IO_UART_FCR_RECEIVER_LSB'       = __IO_UART_FCR_RECEIVER_LSB
defc `__IO_UART_FCR_RECEIVER_MSB'       = __IO_UART_FCR_RECEIVER_MSB

defc `__IO_UART_FCR_FIFO_01'        = __IO_UART_FCR_FIFO_01
defc `__IO_UART_FCR_FIFO_04'        = __IO_UART_FCR_FIFO_04
defc `__IO_UART_FCR_FIFO_08'        = __IO_UART_FCR_FIFO_08
defc `__IO_UART_FCR_FIFO_14'        = __IO_UART_FCR_FIFO_14

defc `__IO_UART_LCR_5BIT'      = __IO_UART_LCR_5BIT
defc `__IO_UART_LCR_6BIT'      = __IO_UART_LCR_6BIT
defc `__IO_UART_LCR_7BIT'      = __IO_UART_LCR_7BIT
defc `__IO_UART_LCR_8BIT'      = __IO_UART_LCR_8BIT
defc `__IO_UART_LCR_STOP'      = __IO_UART_LCR_STOP

defc `__IO_UART_LCR_PARITY_ENABLE'      = __IO_UART_LCR_PARITY_ENABLE
defc `__IO_UART_LCR_PARITY_EVEN'        = __IO_UART_LCR_PARITY_EVEN
defc `__IO_UART_LCR_PARITY_STICK'       = __IO_UART_LCR_PARITY_STICK
defc `__IO_UART_LCR_BREAK_CONTROL'      = __IO_UART_LCR_BREAK_CONTROL
defc `__IO_UART_LCR_DLAB'               = __IO_UART_LCR_DLAB

defc `__IO_UART_MCR_DTR'                = __IO_UART_MCR_DTR
defc `__IO_UART_MCR_RTS'                = __IO_UART_MCR_RTS
defc `__IO_UART_MCR_OUTPUT1'            = __IO_UART_MCR_OUTPUT1
defc `__IO_UART_MCR_INT_ENABLE'         = __IO_UART_MCR_INT_ENABLE
defc `__IO_UART_MCR_LOOPBACK'           = __IO_UART_MCR_LOOPBACK
defc `__IO_UART_MCR_AUTO_FLOW_CONTROL'  = __IO_UART_MCR_AUTO_FLOW_CONTROL

defc `__IO_UART_LSR_DATA_READY'         = __IO_UART_LSR_DATA_READY
defc `__IO_UART_LSR_OVERRUN_ERROR'      = __IO_UART_LSR_OVERRUN_ERROR
defc `__IO_UART_LSR_PARITY_ERROR'       = __IO_UART_LSR_PARITY_ERROR
defc `__IO_UART_LSR_FRAMING_ERROR'      = __IO_UART_LSR_FRAMING_ERROR
defc `__IO_UART_LSR_BREAK_INTERRUPT'    = __IO_UART_LSR_BREAK_INTERRUPT
defc `__IO_UART_LSR_TX_HOLDING_THRE'    = __IO_UART_LSR_TX_HOLDING_THRE
defc `__IO_UART_LSR_TX_EMPTY_TEMT'      = __IO_UART_LSR_TX_EMPTY_TEMT
defc `__IO_UART_LSR_RX_FIFO_ERROR'      = __IO_UART_LSR_RX_FIFO_ERROR

defc `__IO_UART_MSR_CTS_DELTA'      = __IO_UART_MSR_CTS_DELTA
defc `__IO_UART_MSR_DSR_DELTA'      = __IO_UART_MSR_DSR_DELTA
defc `__IO_UART_MSR_TERI'           = __IO_UART_MSR_TERI
defc `__IO_UART_MSR_DCD_DELTA'      = __IO_UART_MSR_DCD_DELTA
defc `__IO_UART_MSR_CTS'            = __IO_UART_MSR_CTS
defc `__IO_UART_MSR_DSR'            = __IO_UART_MSR_DSR
defc `__IO_UART_MSR_RING_INDICATOR' = __IO_UART_MSR_RING_INDICATOR
defc `__IO_UART_MSR_DCD'            = __IO_UART_MSR_DCD

defc `__IO_UART_RX_SIZE'        = __IO_UART_RX_SIZE
defc `__IO_UART_RX_FULLISH'     = __IO_UART_RX_FULLISH
defc `__IO_UART_RX_EMPTYISH'    = __IO_UART_RX_EMPTYISH

defc `__IO_UART_DLL_115200'     = __IO_UART_DLL_115200
defc `__IO_UART_DLL_57600'      = __IO_UART_DLL_57600
defc `__IO_UART_DLL_38400'      = __IO_UART_DLL_38400
defc `__IO_UART_DLL_19200'      = __IO_UART_DLL_19200
defc `__IO_UART_DLL_9600'       = __IO_UART_DLL_9600
defc `__IO_UART_DLL_2400'       = __IO_UART_DLL_2400
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_UARTA_DATA_REGISTER'    __IO_UARTA_DATA_REGISTER
`#define' `__IO_UARTA_IER_REGISTER'     __IO_UARTA_IER_REGISTER
`#define' `__IO_UARTA_IIR_REGISTER'     __IO_UARTA_IIR_REGISTER
`#define' `__IO_UARTA_FCR_REGISTER'     __IO_UARTA_FCR_REGISTER
`#define' `__IO_UARTA_LCR_REGISTER'     __IO_UARTA_LCR_REGISTER
`#define' `__IO_UARTA_MCR_REGISTER'     __IO_UARTA_MCR_REGISTER
`#define' `__IO_UARTA_LSR_REGISTER'     __IO_UARTA_LSR_REGISTER
`#define' `__IO_UARTA_MSR_REGISTER'     __IO_UARTA_MSR_REGISTER
`#define' `__IO_UARTA_SCRATCH_REGISTER' __IO_UARTA_SCRATCH_REGISTER

`#define' `__IO_UARTA_DLL_REGISTER'     __IO_UARTA_DLL_REGISTER
`#define' `__IO_UARTA_DLM_REGISTER'     __IO_UARTA_DLM_REGISTER

`#define' `__IO_UARTB_DATA_REGISTER'    __IO_UARTB_DATA_REGISTER
`#define' `__IO_UARTB_IER_REGISTER'     __IO_UARTB_IER_REGISTER
`#define' `__IO_UARTB_IIR_REGISTER'     __IO_UARTB_IIR_REGISTER
`#define' `__IO_UARTB_FCR_REGISTER'     __IO_UARTB_FCR_REGISTER
`#define' `__IO_UARTB_LCR_REGISTER'     __IO_UARTB_LCR_REGISTER
`#define' `__IO_UARTB_MCR_REGISTER'     __IO_UARTB_MCR_REGISTER
`#define' `__IO_UARTB_LSR_REGISTER'     __IO_UARTB_LSR_REGISTER
`#define' `__IO_UARTB_MSR_REGISTER'     __IO_UARTB_MSR_REGISTER
`#define' `__IO_UARTB_SCRATCH_REGISTER' __IO_UARTB_SCRATCH_REGISTER

`#define' `__IO_UARTB_DLL_REGISTER'     __IO_UARTB_DLL_REGISTER
`#define' `__IO_UARTB_DLM_REGISTER'     __IO_UARTB_DLM_REGISTER

`#define' `__IO_UART_IER_ERBI'          __IO_UART_IER_ERBI
`#define' `__IO_UART_IER_ETBEI'         __IO_UART_IER_ETBEI
`#define' `__IO_UART_IER_ETSI'          __IO_UART_IER_ETSI
`#define' `__IO_UART_IER_EDSSI'         __IO_UART_IER_EDSSI

`#define' `__IO_UART_IIR_PENDING'       __IO_UART_IIR_PENDING
`#define' `__IO_UART_IIR_ID_1'          __IO_UART_IIR_ID_1
`#define' `__IO_UART_IIR_ID_2'          __IO_UART_IIR_ID_2
`#define' `__IO_UART_IIR_ID_3'          __IO_UART_IIR_ID_3
`#define' `__IO_UART_IIR_FIFO_LSB'      __IO_UART_IIR_FIFO_LSB
`#define' `__IO_UART_IIR_FIFO_MSB'      __IO_UART_IIR_FIFO_MSB

`#define' `__IO_UART_IIR_THRE'          __IO_UART_IIR_THRE
`#define' `__IO_UART_IIR_DATA'          __IO_UART_IIR_DATA
`#define' `__IO_UART_IIR_RLS'           __IO_UART_IIR_RLS
`#define' `__IO_UART_IIR_TIMEOUT'       __IO_UART_IIR_TIMEOUT
`#define' `__IO_UART_IIR_MASK'          __IO_UART_IIR_MASK

`#define' `__IO_UART_FCR_FIFO_ENABLE'       __IO_UART_FCR_FIFO_ENABLE
`#define' `__IO_UART_FCR_FIFO_RX_RESET'     __IO_UART_FCR_FIFO_RX_RESET
`#define' `__IO_UART_FCR_FIFO_TX_RESET'     __IO_UART_FCR_FIFO_TX_RESET
`#define' `__IO_UART_FCR_DMA_MODE_SELECT'   __IO_UART_FCR_DMA_MODE_SELECT
`#define' `__IO_UART_FCR_RECEIVER_LSB'      __IO_UART_FCR_RECEIVER_LSB
`#define' `__IO_UART_FCR_RECEIVER_MSB'      __IO_UART_FCR_RECEIVER_MSB

`#define' `__IO_UART_FCR_FIFO_01'      __IO_UART_FCR_FIFO_01
`#define' `__IO_UART_FCR_FIFO_04'      __IO_UART_FCR_FIFO_04
`#define' `__IO_UART_FCR_FIFO_08'      __IO_UART_FCR_FIFO_08
`#define' `__IO_UART_FCR_FIFO_14'      __IO_UART_FCR_FIFO_14

`#define' `__IO_UART_LCR_5BIT'      __IO_UART_LCR_5BIT
`#define' `__IO_UART_LCR_6BIT'      __IO_UART_LCR_6BIT
`#define' `__IO_UART_LCR_7BIT'      __IO_UART_LCR_7BIT
`#define' `__IO_UART_LCR_8BIT'      __IO_UART_LCR_8BIT

`#define' `__IO_UART_LCR_STOP'          __IO_UART_LCR_STOP
`#define' `__IO_UART_LCR_PARITY_ENABLE' __IO_UART_LCR_PARITY_ENABLE
`#define' `__IO_UART_LCR_PARITY_EVEN'   __IO_UART_LCR_PARITY_EVEN
`#define' `__IO_UART_LCR_PARITY_STICK'  __IO_UART_LCR_PARITY_STICK
`#define' `__IO_UART_LCR_BREAK_CONTROL' __IO_UART_LCR_BREAK_CONTROL
`#define' `__IO_UART_LCR_DLAB'          __IO_UART_LCR_DLAB

`#define' `__IO_UART_MCR_DTR'               __IO_UART_MCR_DTR
`#define' `__IO_UART_MCR_RTS'               __IO_UART_MCR_RTS
`#define' `__IO_UART_MCR_OUTPUT1'           __IO_UART_MCR_OUTPUT1
`#define' `__IO_UART_MCR_INT_ENABLE'        __IO_UART_MCR_INT_ENABLE
`#define' `__IO_UART_MCR_LOOPBACK'          __IO_UART_MCR_LOOPBACK
`#define' `__IO_UART_MCR_AUTO_FLOW_CONTROL' __IO_UART_MCR_AUTO_FLOW_CONTROL

`#define' `__IO_UART_LSR_DATA_READY'        __IO_UART_LSR_DATA_READY
`#define' `__IO_UART_LSR_OVERRUN_ERROR'     __IO_UART_LSR_OVERRUN_ERROR
`#define' `__IO_UART_LSR_PARITY_ERROR'      __IO_UART_LSR_PARITY_ERROR
`#define' `__IO_UART_LSR_FRAMING_ERROR'     __IO_UART_LSR_FRAMING_ERROR
`#define' `__IO_UART_LSR_BREAK_INTERRUPT'   __IO_UART_LSR_BREAK_INTERRUPT
`#define' `__IO_UART_LSR_TX_HOLDING_THRE'   __IO_UART_LSR_TX_HOLDING_THRE
`#define' `__IO_UART_LSR_TX_EMPTY_TEMT'     __IO_UART_LSR_TX_EMPTY_TEMT
`#define' `__IO_UART_LSR_RX_FIFO_ERROR'     __IO_UART_LSR_RX_FIFO_ERROR

`#define' `__IO_UART_MSR_CTS_DELTA'         __IO_UART_MSR_CTS_DELTA
`#define' `__IO_UART_MSR_DSR_DELTA'         __IO_UART_MSR_DSR_DELTA
`#define' `__IO_UART_MSR_TERI'              __IO_UART_MSR_TERI
`#define' `__IO_UART_MSR_DCD_DELTA'         __IO_UART_MSR_DCD_DELTA
`#define' `__IO_UART_MSR_CTS'               __IO_UART_MSR_CTS
`#define' `__IO_UART_MSR_DSR'               __IO_UART_MSR_DSR
`#define' `__IO_UART_MSR_RING_INDICATOR'    __IO_UART_MSR_RING_INDICATOR
`#define' `__IO_UART_MSR_DCD'               __IO_UART_MSR_DCD

`#define' `__IO_UART_RX_SIZE'        __IO_UART_RX_SIZE
`#define' `__IO_UART_RX_FULLISH'     __IO_UART_RX_FULLISH
`#define' `__IO_UART_RX_EMPTYISH'    __IO_UART_RX_EMPTYISH

`#define' `__IO_UART_DLL_115200'     __IO_UART_DLL_115200
`#define' `__IO_UART_DLL_57600'      __IO_UART_DLL_57600
`#define' `__IO_UART_DLL_38400'      __IO_UART_DLL_38400
`#define' `__IO_UART_DLL_19200'      __IO_UART_DLL_19200
`#define' `__IO_UART_DLL_9600'       __IO_UART_DLL_9600
`#define' `__IO_UART_DLL_2400'       __IO_UART_DLL_2400
')
