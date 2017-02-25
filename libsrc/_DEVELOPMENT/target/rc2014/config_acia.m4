divert(-1)

###############################################################
# MC68C50 ACIA CONFIGURATION
# rebuild the library if changes are made
#

define(`ACIA_CTRL_ADDR', 0x80)      # Address of Control Register (write only)
define(`ACIA_STATUS_ADDR', 0x80)    # Address of Status Register (read only)
define(`ACIA_DATA_ADDR', 0x81)      # Address of Data Register

define(`ACIA_CLK_DIV_01', 0x00)     # Divide the Clock by 1
define(`ACIA_CLK_DIV_16', 0x01)     # Divide the Clock by 16
define(`ACIA_CLK_DIV_64', 0x02)     # Divide the Clock by 64 (default value)
define(`ACIA_RESET', 0x03)          # Master Reset (issue before any other Control word)

define(`ACIA_7E2', 0x00)            # 7 Bits Even Parity 2 Stop Bits
define(`ACIA_7O2', 0x04)            # 7 Bits  Odd Parity 2 Stop Bits
define(`ACIA_7E1', 0x08)            # 7 Bits Even Parity 1 Stop Bit
define(`ACIA_7O1', 0x0C)            # 7 Bits  Odd Parity 1 Stop Bit
define(`ACIA_8N2', 0x10)            # 8 Bits   No Parity 2 Stop Bits
define(`ACIA_8N1', 0x14)            # 8 Bits   No Parity 1 Stop Bit
define(`ACIA_8E1', 0x18)            # 8 Bits Even Parity 1 Stop Bit
define(`ACIA_8O1', 0x1C)            # 8 Bits  Odd Parity 1 Stop Bit

define(`ACIA_TDI_RTS0', 0x00)       # _RTS low,  Transmitting Interrupt Disabled
define(`ACIA_TEI_RTS0', 0x20)       # _RTS low,  Transmitting Interrupt Enabled
define(`ACIA_TDI_RTS1', 0x40)       # _RTS high, Transmitting Interrupt Disabled
define(`ACIA_TDI_BRK', 0x60)        # _RTS low,  Transmitting Interrupt Disabled, BRK on Tx
   
define(`ACIA_TEI_MASK', 0x60)       # Mask for the Tx Interrupt & RTS bits

define(`ACIA_REI', 0x80)            # Receive Interrupt Enabled

define(`ACIA_RDRF', 0x01)           # Receive Data Register Full
define(`ACIA_TDRE', 0x02)           # Transmit Data Register Empty
define(`ACIA_DCD', 0x04)            # Data Carrier Detect
define(`ACIA_CTS', 0x08)            # Clear To Send
define(`ACIA_FE', 0x10)             # Framing Error (Received Byte)
define(`ACIA_OVRN', 0x20)           # Overrun (Received Byte
define(`ACIA_PE', 0x40)             # Parity Error (Received Byte)
define(`ACIA_IRQ', 0x80)            # IRQ (Either Transmitted or Received Byte)

# MC68C50 ACIA driver

define(`ACIA_RX_SIZE', 0x80)        # Size of the Rx Buffer
define(`ACIA_RX_FULLISH', eval(ACIA_RX_SIZE-4))   # Size of the Rx Buffer, when not_RTS is signalled
define(`ACIA_TX_SIZE', 0x80)        # Size of the Tx Buffer   

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `ACIA_CTRL_ADDR'
PUBLIC `ACIA_STATUS_ADDR'
PUBLIC `ACIA_DATA_ADDR'

PUBLIC `ACIA_CLK_DIV_01'
PUBLIC `ACIA_CLK_DIV_16'
PUBLIC `ACIA_CLK_DIV_64'
PUBLIC `ACIA_RESET'

PUBLIC `ACIA_7E2'
PUBLIC `ACIA_7O2'
PUBLIC `ACIA_7E1'
PUBLIC `ACIA_7O1'
PUBLIC `ACIA_8N2'
PUBLIC `ACIA_8N1'
PUBLIC `ACIA_8E1'
PUBLIC `ACIA_8O1'

PUBLIC `ACIA_TDI_RTS0'
PUBLIC `ACIA_TEI_RTS0'
PUBLIC `ACIA_TDI_RTS1'
PUBLIC `ACIA_TDI_BRK'
   
PUBLIC `ACIA_TEI_MASK'

PUBLIC `ACIA_REI'

PUBLIC `ACIA_RDRF'
PUBLIC `ACIA_TDRE'
PUBLIC `ACIA_DCD'
PUBLIC `ACIA_CTS'
PUBLIC `ACIA_FE'
PUBLIC `ACIA_OVRN'
PUBLIC `ACIA_PE'
PUBLIC `ACIA_IRQ'

PUBLIC `ACIA_RX_SIZE'
PUBLIC `ACIA_RX_FULLISH'
PUBLIC `ACIA_TX_SIZE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `ACIA_CTRL_ADDR'   = ACIA_CTRL_ADDR
defc `ACIA_STATUS_ADDR' = ACIA_STATUS_ADDR
defc `ACIA_DATA_ADDR'   = ACIA_DATA_ADDR

defc `ACIA_CLK_DIV_01'  = ACIA_CLK_DIV_01
defc `ACIA_CLK_DIV_16'  = ACIA_CLK_DIV_16
defc `ACIA_CLK_DIV_64'  = ACIA_CLK_DIV_64
defc `ACIA_RESET'       = ACIA_RESET

defc `ACIA_7E2'         = ACIA_7E2
defc `ACIA_7O2'         = ACIA_7O2
defc `ACIA_7E1'         = ACIA_7E1
defc `ACIA_7O1'         = ACIA_7O1
defc `ACIA_8N2'         = ACIA_8N2
defc `ACIA_8N1'         = ACIA_8N1
defc `ACIA_8E1'         = ACIA_8E1
defc `ACIA_8O1'         = ACIA_8O1

defc `ACIA_TDI_RTS0'    = ACIA_TDI_RTS0
defc `ACIA_TEI_RTS0'    = ACIA_TEI_RTS0
defc `ACIA_TDI_RTS1'    = ACIA_TDI_RTS1
defc `ACIA_TDI_BRK'     = ACIA_TDI_BRK
   
defc `ACIA_TEI_MASK'    = ACIA_TEI_MASK

defc `ACIA_REI'         = ACIA_REI

defc `ACIA_RDRF'        = ACIA_RDRF
defc `ACIA_TDRE'        = ACIA_TDRE
defc `ACIA_DCD'         = ACIA_DCD
defc `ACIA_CTS'         = ACIA_CTS
defc `ACIA_FE'          = ACIA_FE
defc `ACIA_OVRN'        = ACIA_OVRN
defc `ACIA_PE'          = ACIA_PE
defc `ACIA_IRQ'         = ACIA_IRQ

defc `ACIA_RX_SIZE'     = ACIA_RX_SIZE
defc `ACIA_RX_FULLISH'  = ACIA_RX_FULLISH
defc `ACIA_TX_SIZE'     = ACIA_TX_SIZE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `ACIA_CTRL_ADDR'    ACIA_CTRL_ADDR
`#define' `ACIA_STATUS_ADDR'  ACIA_STATUS_ADDR
`#define' `ACIA_DATA_ADDR'    ACIA_DATA_ADDR

`#define' `ACIA_CLK_DIV_01'   ACIA_CLK_DIV_01
`#define' `ACIA_CLK_DIV_16'   ACIA_CLK_DIV_16
`#define' `ACIA_CLK_DIV_64'   ACIA_CLK_DIV_64
`#define' `ACIA_RESET'        ACIA_RESET

`#define' `ACIA_7E2'          ACIA_7E2
`#define' `ACIA_7O2'          ACIA_7O2
`#define' `ACIA_7E1'          ACIA_7E1
`#define' `ACIA_7O1'          ACIA_7O1
`#define' `ACIA_8N2'          ACIA_8N2
`#define' `ACIA_8N1'          ACIA_8N1
`#define' `ACIA_8E1'          ACIA_8E1
`#define' `ACIA_8O1'          ACIA_8O1

`#define' `ACIA_TDI_RTS0'     ACIA_TDI_RTS0
`#define' `ACIA_TEI_RTS0'     ACIA_TEI_RTS0
`#define' `ACIA_TDI_RTS1'     ACIA_TDI_RTS1
`#define' `ACIA_TDI_BRK'      ACIA_TDI_BRK
   
`#define' `ACIA_TEI_MASK'     ACIA_TEI_MASK

`#define' `ACIA_REI'          ACIA_REI

`#define' `ACIA_RDRF'         ACIA_RDRF
`#define' `ACIA_TDRE'         ACIA_TDRE
`#define' `ACIA_DCD'          ACIA_DCD
`#define' `ACIA_CTS'          ACIA_CTS
`#define' `ACIA_FE'           ACIA_FE
`#define' `ACIA_OVRN'         ACIA_OVRN
`#define' `ACIA_PE'           ACIA_PE
`#define' `ACIA_IRQ'          ACIA_IRQ

`#define' `ACIA_RX_SIZE'      ACIA_RX_SIZE
`#define' `ACIA_RX_FULLISH'   ACIA_RX_FULLISH
`#define' `ACIA_TX_SIZE'      ACIA_TX_SIZE
')
