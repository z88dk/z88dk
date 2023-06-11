divert(-1)

###############################################################
# MC68C50 ACIA CONFIGURATION
# rebuild the library if changes are made
#

define(`__IO_ACIA_CONTROL_REGISTER', 0x`'eval(__IO_ACIA_PORT_BASE+0x00,16)) # Address of Control Register (write only)
define(`__IO_ACIA_STATUS_REGISTER', 0x`'eval(__IO_ACIA_PORT_BASE+0x00,16))  # Address of Status Register (read only)
define(`__IO_ACIA_DATA_REGISTER', 0x`'eval(__IO_ACIA_PORT_BASE+0x01,16))    # Address of Data Register

define(`__IO_ACIA_CR_CLK_DIV_01', 0x00)    # Divide the Clock by 1
define(`__IO_ACIA_CR_CLK_DIV_16', 0x01)    # Divide the Clock by 16
define(`__IO_ACIA_CR_CLK_DIV_64', 0x02)    # Divide the Clock by 64 (default value)
define(`__IO_ACIA_CR_RESET', 0x03)         # Master Reset (issue before any other Control word)

define(`__IO_ACIA_CR_7E2', 0x00)           # 7 Bits Even Parity 2 Stop Bits
define(`__IO_ACIA_CR_7O2', 0x04)           # 7 Bits  Odd Parity 2 Stop Bits
define(`__IO_ACIA_CR_7E1', 0x08)           # 7 Bits Even Parity 1 Stop Bit
define(`__IO_ACIA_CR_7O1', 0x0C)           # 7 Bits  Odd Parity 1 Stop Bit
define(`__IO_ACIA_CR_8N2', 0x10)           # 8 Bits   No Parity 2 Stop Bits
define(`__IO_ACIA_CR_8N1', 0x14)           # 8 Bits   No Parity 1 Stop Bit
define(`__IO_ACIA_CR_8E1', 0x18)           # 8 Bits Even Parity 1 Stop Bit
define(`__IO_ACIA_CR_8O1', 0x1C)           # 8 Bits  Odd Parity 1 Stop Bit

define(`__IO_ACIA_CR_TDI_RTS0', 0x00)      # _RTS low,  Transmitting Interrupt Disabled
define(`__IO_ACIA_CR_TEI_RTS0', 0x20)      # _RTS low,  Transmitting Interrupt Enabled
define(`__IO_ACIA_CR_TDI_RTS1', 0x40)      # _RTS high, Transmitting Interrupt Disabled
define(`__IO_ACIA_CR_TDI_BRK', 0x60)       # _RTS low,  Transmitting Interrupt Disabled, BRK on Tx
   
define(`__IO_ACIA_CR_TEI_MASK', 0x60)      # Mask for the Tx Interrupt & RTS bits

define(`__IO_ACIA_CR_REI', 0x80)           # Receive Interrupt Enabled

define(`__IO_ACIA_SR_RDRF', 0x01)          # Receive Data Register Full
define(`__IO_ACIA_SR_TDRE', 0x02)          # Transmit Data Register Empty
define(`__IO_ACIA_SR_DCD', 0x04)           # Data Carrier Detect
define(`__IO_ACIA_SR_CTS', 0x08)           # Clear To Send
define(`__IO_ACIA_SR_FE', 0x10)            # Framing Error (Received Byte)
define(`__IO_ACIA_SR_OVRN', 0x20)          # Overrun (Received Byte
define(`__IO_ACIA_SR_PE', 0x40)            # Parity Error (Received Byte)
define(`__IO_ACIA_SR_IRQ', 0x80)           # IRQ (Either Transmitted or Received Byte)

# MC68C50 ACIA driver

define(`__IO_ACIA_RX_SIZE', 0x100)         # Size of the Rx Buffer, must be 2^n >= 8 (Default)
define(`__IO_ACIA_RX_FULLISH', 0x`'eval(__IO_ACIA_RX_SIZE-16,16))
                                           # Fullness of the Rx Buffer, when NOT_RTS is signalled
define(`__IO_ACIA_RX_EMPTYISH', 0x08)      # Fullness of the Rx Buffer, when RTS is signalled
define(`__IO_ACIA_TX_SIZE', 0x10)          # Size of the Tx Buffer, must be 2^n >= 8 (Default)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_ACIA_CONTROL_REGISTER'
PUBLIC `__IO_ACIA_STATUS_REGISTER'
PUBLIC `__IO_ACIA_DATA_REGISTER'

PUBLIC `__IO_ACIA_CR_CLK_DIV_01'
PUBLIC `__IO_ACIA_CR_CLK_DIV_16'
PUBLIC `__IO_ACIA_CR_CLK_DIV_64'
PUBLIC `__IO_ACIA_CR_RESET'

PUBLIC `__IO_ACIA_CR_7E2'
PUBLIC `__IO_ACIA_CR_7O2'
PUBLIC `__IO_ACIA_CR_7E1'
PUBLIC `__IO_ACIA_CR_7O1'
PUBLIC `__IO_ACIA_CR_8N2'
PUBLIC `__IO_ACIA_CR_8N1'
PUBLIC `__IO_ACIA_CR_8E1'
PUBLIC `__IO_ACIA_CR_8O1'

PUBLIC `__IO_ACIA_CR_TDI_RTS0'
PUBLIC `__IO_ACIA_CR_TEI_RTS0'
PUBLIC `__IO_ACIA_CR_TDI_RTS1'
PUBLIC `__IO_ACIA_CR_TDI_BRK'
   
PUBLIC `__IO_ACIA_CR_TEI_MASK'

PUBLIC `__IO_ACIA_CR_REI'

PUBLIC `__IO_ACIA_SR_RDRF'
PUBLIC `__IO_ACIA_SR_TDRE'
PUBLIC `__IO_ACIA_SR_DCD'
PUBLIC `__IO_ACIA_SR_CTS'
PUBLIC `__IO_ACIA_SR_FE'
PUBLIC `__IO_ACIA_SR_OVRN'
PUBLIC `__IO_ACIA_SR_PE'
PUBLIC `__IO_ACIA_SR_IRQ'

PUBLIC `__IO_ACIA_RX_SIZE'
PUBLIC `__IO_ACIA_RX_FULLISH'
PUBLIC `__IO_ACIA_RX_EMPTYISH'
PUBLIC `__IO_ACIA_TX_SIZE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_ACIA_CONTROL_REGISTER'   = __IO_ACIA_CONTROL_REGISTER
defc `__IO_ACIA_STATUS_REGISTER' = __IO_ACIA_STATUS_REGISTER
defc `__IO_ACIA_DATA_REGISTER'   = __IO_ACIA_DATA_REGISTER

defc `__IO_ACIA_CR_CLK_DIV_01'  = __IO_ACIA_CR_CLK_DIV_01
defc `__IO_ACIA_CR_CLK_DIV_16'  = __IO_ACIA_CR_CLK_DIV_16
defc `__IO_ACIA_CR_CLK_DIV_64'  = __IO_ACIA_CR_CLK_DIV_64
defc `__IO_ACIA_CR_RESET'       = __IO_ACIA_CR_RESET

defc `__IO_ACIA_CR_7E2'         = __IO_ACIA_CR_7E2
defc `__IO_ACIA_CR_7O2'         = __IO_ACIA_CR_7O2
defc `__IO_ACIA_CR_7E1'         = __IO_ACIA_CR_7E1
defc `__IO_ACIA_CR_7O1'         = __IO_ACIA_CR_7O1
defc `__IO_ACIA_CR_8N2'         = __IO_ACIA_CR_8N2
defc `__IO_ACIA_CR_8N1'         = __IO_ACIA_CR_8N1
defc `__IO_ACIA_CR_8E1'         = __IO_ACIA_CR_8E1
defc `__IO_ACIA_CR_8O1'         = __IO_ACIA_CR_8O1

defc `__IO_ACIA_CR_TDI_RTS0'    = __IO_ACIA_CR_TDI_RTS0
defc `__IO_ACIA_CR_TEI_RTS0'    = __IO_ACIA_CR_TEI_RTS0
defc `__IO_ACIA_CR_TDI_RTS1'    = __IO_ACIA_CR_TDI_RTS1
defc `__IO_ACIA_CR_TDI_BRK'     = __IO_ACIA_CR_TDI_BRK
   
defc `__IO_ACIA_CR_TEI_MASK'    = __IO_ACIA_CR_TEI_MASK

defc `__IO_ACIA_CR_REI'         = __IO_ACIA_CR_REI

defc `__IO_ACIA_SR_RDRF'        = __IO_ACIA_SR_RDRF
defc `__IO_ACIA_SR_TDRE'        = __IO_ACIA_SR_TDRE
defc `__IO_ACIA_SR_DCD'         = __IO_ACIA_SR_DCD
defc `__IO_ACIA_SR_CTS'         = __IO_ACIA_SR_CTS
defc `__IO_ACIA_SR_FE'          = __IO_ACIA_SR_FE
defc `__IO_ACIA_SR_OVRN'        = __IO_ACIA_SR_OVRN
defc `__IO_ACIA_SR_PE'          = __IO_ACIA_SR_PE
defc `__IO_ACIA_SR_IRQ'         = __IO_ACIA_SR_IRQ

defc `__IO_ACIA_RX_SIZE'     = __IO_ACIA_RX_SIZE
defc `__IO_ACIA_RX_FULLISH'  = __IO_ACIA_RX_FULLISH
defc `__IO_ACIA_RX_EMPTYISH' = __IO_ACIA_RX_EMPTYISH
defc `__IO_ACIA_TX_SIZE'     = __IO_ACIA_TX_SIZE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_ACIA_CONTROL_REGISTER'    __IO_ACIA_CONTROL_REGISTER
`#define' `__IO_ACIA_STATUS_REGISTER'  __IO_ACIA_STATUS_REGISTER
`#define' `__IO_ACIA_DATA_REGISTER'    __IO_ACIA_DATA_REGISTER

`#define' `__IO_ACIA_CR_CLK_DIV_01'   __IO_ACIA_CR_CLK_DIV_01
`#define' `__IO_ACIA_CR_CLK_DIV_16'   __IO_ACIA_CR_CLK_DIV_16
`#define' `__IO_ACIA_CR_CLK_DIV_64'   __IO_ACIA_CR_CLK_DIV_64
`#define' `__IO_ACIA_CR_RESET'        __IO_ACIA_CR_RESET

`#define' `__IO_ACIA_CR_7E2'          __IO_ACIA_CR_7E2
`#define' `__IO_ACIA_CR_7O2'          __IO_ACIA_CR_7O2
`#define' `__IO_ACIA_CR_7E1'          __IO_ACIA_CR_7E1
`#define' `__IO_ACIA_CR_7O1'          __IO_ACIA_CR_7O1
`#define' `__IO_ACIA_CR_8N2'          __IO_ACIA_CR_8N2
`#define' `__IO_ACIA_CR_8N1'          __IO_ACIA_CR_8N1
`#define' `__IO_ACIA_CR_8E1'          __IO_ACIA_CR_8E1
`#define' `__IO_ACIA_CR_8O1'          __IO_ACIA_CR_8O1

`#define' `__IO_ACIA_CR_TDI_RTS0'     __IO_ACIA_CR_TDI_RTS0
`#define' `__IO_ACIA_CR_TEI_RTS0'     __IO_ACIA_CR_TEI_RTS0
`#define' `__IO_ACIA_CR_TDI_RTS1'     __IO_ACIA_CR_TDI_RTS1
`#define' `__IO_ACIA_CR_TDI_BRK'      __IO_ACIA_CR_TDI_BRK
   
`#define' `__IO_ACIA_CR_TEI_MASK'     __IO_ACIA_CR_TEI_MASK

`#define' `__IO_ACIA_CR_REI'          __IO_ACIA_CR_REI

`#define' `__IO_ACIA_SR_RDRF'         __IO_ACIA_SR_RDRF
`#define' `__IO_ACIA_SR_TDRE'         __IO_ACIA_SR_TDRE
`#define' `__IO_ACIA_SR_DCD'          __IO_ACIA_SR_DCD
`#define' `__IO_ACIA_SR_CTS'          __IO_ACIA_SR_CTS
`#define' `__IO_ACIA_SR_FE'           __IO_ACIA_SR_FE
`#define' `__IO_ACIA_SR_OVRN'         __IO_ACIA_SR_OVRN
`#define' `__IO_ACIA_SR_PE'           __IO_ACIA_SR_PE
`#define' `__IO_ACIA_SR_IRQ'          __IO_ACIA_SR_IRQ

`#define' `__IO_ACIA_RX_SIZE'      __IO_ACIA_RX_SIZE
`#define' `__IO_ACIA_RX_FULLISH'   __IO_ACIA_RX_FULLISH
`#define' `__IO_ACIA_RX_EMPTYISH' __IO_ACIA_RX_EMPTYISH
`#define' `__IO_ACIA_TX_SIZE'      __IO_ACIA_TX_SIZE
')
