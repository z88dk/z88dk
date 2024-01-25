divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__RCM2024', 1)

# Clock frequency in Hz

define(`__CPU_CLOCK', 29491200)

# R2KA serial C driver

define(`__SC_RX_SIZE', 0x100)                    # Size of the Rx Buffer, must be 2^n >= 8 (Default)
define(`__SC_RX_FULLISH', 0x`'eval(__SC_RX_SIZE-16,16))
                                                    # Fullness of the Rx Buffer, when NOT_RTS is signalled
define(`__SC_RX_EMPTYISH', 0x08)                 # Fullness of the Rx Buffer, when RTS is signalled
define(`__SC_TX_SIZE', 0x080)                    # Size of the Tx Buffer, must be 2^n >= 8 (Default)

# R2KA serial D driver

define(`__SD_RX_SIZE', 0x100)                    # Size of the Rx Buffer, must be 2^n >= 8 (Default)
define(`__SD_RX_FULLISH', 0x`'eval(__SD_RX_SIZE-16,16))
                                                    # Fullness of the Rx Buffer, when NOT_RTS is signalled
define(`__SD_RX_EMPTYISH', 0x08)                 # Fullness of the Rx Buffer, when RTS is signalled
define(`__SD_TX_SIZE', 0x080)                    # Size of the Tx Buffer, must be 2^n >= 8 (Default)

# Digital I/O Module Port Definition

define(`__IO_DIO_PORT', 0x00)    # Port Address for DIO Module

# Compact Flash Module Port Definition

define(`__IO_CF_8_BIT', 0x01)       # Use 8-bit mode for CF Module (0x01)
define(`__IO_CF_PORT_BASE', 0x10)   # Port Address for CF Module

# 82C55 PIO Port Definition

define(`__IO_PIO_PORT_BASE', 0x20)  # Port Address for 82C55 Module

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__RCM2024'

PUBLIC `__SC_RX_SIZE'
PUBLIC `__SC_RX_FULLISH'
PUBLIC `__SC_RX_EMPTYISH'
PUBLIC `__SC_TX_SIZE'

PUBLIC `__SD_RX_SIZE'
PUBLIC `__SD_RX_FULLISH'
PUBLIC `__SD_RX_EMPTYISH'
PUBLIC `__SD_TX_SIZE'

PUBLIC `__IO_DIO_PORT'
PUBLIC `__IO_CF_8_BIT'
PUBLIC `__IO_CF_PORT_BASE'
PUBLIC `__IO_PIO_PORT_BASE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__RCM2024' = __RCM2024

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__SC_RX_SIZE' = __SC_RX_SIZE
defc `__SC_RX_FULLISH' = __SC_RX_FULLISH
defc `__SC_RX_EMPTYISH' = __SC_RX_EMPTYISH
defc `__SC_TX_SIZE' = __SC_TX_SIZE

defc `__SD_RX_SIZE' = __SD_RX_SIZE
defc `__SD_RX_FULLISH' = __SD_RX_FULLISH
defc `__SD_RX_EMPTYISH' = __SD_RX_EMPTYISH
defc `__SD_TX_SIZE' = __SD_TX_SIZE

defc `__IO_DIO_PORT' = __IO_DIO_PORT
defc `__IO_CF_8_BIT' = __IO_CF_8_BIT
defc `__IO_CF_PORT_BASE' = __IO_CF_PORT_BASE
defc `__IO_PIO_PORT_BASE' = __IO_PIO_PORT_BASE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__RCM2024'
`#define' `__RCM2024'  __RCM2024

`#define' `__SC_RX_SIZE'  __SC_RX_SIZE
`#define' `__SC_RX_FULLISH'  __SC_RX_FULLISH
`#define' `__SC_RX_EMPTYISH'  __SC_RX_EMPTYISH
`#define' `__SC_TX_SIZE'  __SC_TX_SIZE

`#define' `__SD_RX_SIZE'  __SD_RX_SIZE
`#define' `__SD_RX_FULLISH'  __SD_RX_FULLISH
`#define' `__SD_RX_EMPTYISH'  __SD_RX_EMPTYISH
`#define' `__SD_TX_SIZE'  __SD_TX_SIZE

`#define' `__IO_DIO_PORT'  __IO_DIO_PORT
`#define' `__IO_CF_8_BIT'  __IO_CF_8_BIT
`#define' `__IO_CF_PORT_BASE'  __IO_CF_PORT_BASE
`#define' `__IO_PIO_PORT_BASE'  __IO_PIO_PORT_BASE
')
