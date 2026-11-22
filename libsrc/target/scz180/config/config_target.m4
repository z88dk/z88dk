divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__SCZ180', 1)

# Clock frequency in Hz

define(`__CPU_CLOCK', 18432000)

# Frequency of PRT0 if configured as per normal

define(`__CLOCKS_PER_SECOND', 50)

# Z180 ASCI0 driver

define(`__ASCI0_RX_SIZE', 0x100)                    # Size of the Rx Buffer, must be 2^n >= 8 (Default)
define(`__ASCI0_RX_FULLISH', 0x`'eval(__ASCI0_RX_SIZE-16,16))
                                                    # Fullness of the Rx Buffer, when NOT_RTS is signalled
define(`__ASCI0_RX_EMPTYISH', 0x08)                 # Fullness of the Rx Buffer, when RTS is signalled
define(`__ASCI0_TX_SIZE', 0x080)                    # Size of the Tx Buffer, must be 2^n >= 8 (Default)

# Z180 ASCI1 driver

define(`__ASCI1_RX_SIZE', 0x100)  # Size of the Rx Buffer, must be 2^n >= 8 (Default)
define(`__ASCI1_TX_SIZE', 0x080)  # Size of the Tx Buffer, must be 2^n >= 8 (Default)

# I/O BASE ADDRESS OF INTERNAL PERIPHERALS

define(`__IO_BASE_ADDRESS', 0xC0)

define(`__IO_BASE_ADDRESS', 0x`'eval(__IO_BASE_ADDRESS&0xc0,16))

# Digital I/O Module Port Definition

define(`__IO_DIO_PORT', 0x00)       # Port Address for Spencer's DIO

# System Port Definitions

define(`__IO_SYSTEM', 0x0C)         # Port Address for System I/O (SPI - Bit 2)
define(`__IO_LED_OUTPUT', 0x0D)     # Port Address for LED Output (via SC129)
define(`__IO_LED_STATUS', 0x0E)     # Port Address for status LED (Inverted Bit 0)

# Compact Flash Module Port Definition

define(`__IO_CF_PORT', 0x10)        # Port Address for Spencer's CF

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__SCZ180'

PUBLIC `__CPU_CLOCK'

PUBLIC `__CLOCKS_PER_SECOND'

PUBLIC `__ASCI0_RX_SIZE'
PUBLIC `__ASCI0_RX_FULLISH'
PUBLIC `__ASCI0_RX_EMPTYISH'
PUBLIC `__ASCI0_TX_SIZE'

PUBLIC `__ASCI1_RX_SIZE'
PUBLIC `__ASCI1_TX_SIZE'

PUBLIC `__IO_BASE_ADDRESS'

PUBLIC `__IO_DIO_PORT'

PUBLIC `__IO_SYSTEM'
PUBLIC `__IO_LED_OUTPUT'
PUBLIC `__IO_LED_STATUS'

PUBLIC `__IO_CF_PORT'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__SCZ180' = __SCZ180

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__CLOCKS_PER_SECOND' = __CLOCKS_PER_SECOND

defc `__ASCI0_RX_SIZE' = __ASCI0_RX_SIZE
defc `__ASCI0_RX_FULLISH' = __ASCI0_RX_FULLISH
defc `__ASCI0_RX_EMPTYISH' = __ASCI0_RX_EMPTYISH
defc `__ASCI0_TX_SIZE' = __ASCI0_TX_SIZE

defc `__ASCI1_RX_SIZE' = __ASCI1_RX_SIZE
defc `__ASCI1_TX_SIZE' = __ASCI1_TX_SIZE

defc `__IO_BASE_ADDRESS' = __IO_BASE_ADDRESS

defc `__IO_DIO_PORT' = __IO_DIO_PORT

defc `__IO_SYSTEM' = __IO_SYSTEM
defc `__IO_LED_OUTPUT' = __IO_LED_OUTPUT
defc `__IO_LED_STATUS' = __IO_LED_STATUS

defc `__IO_CF_PORT' = __IO_CF_PORT
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__SCZ180'
`#define' `__SCZ180'  __SCZ180

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__CLOCKS_PER_SECOND' __CLOCKS_PER_SECOND

`#define' `__ASCI0_RX_SIZE'  __ASCI0_RX_SIZE
`#define' `__ASCI0_RX_FULLISH'  __ASCI0_RX_FULLISH
`#define' `__ASCI0_RX_EMPTYISH'  __ASCI0_RX_EMPTYISH
`#define' `__ASCI0_TX_SIZE'  __ASCI0_TX_SIZE

`#define' `__ASCI1_RX_SIZE'  __ASCI1_RX_SIZE
`#define' `__ASCI1_TX_SIZE'  __ASCI1_TX_SIZE

`#define' `__IO_BASE_ADDRESS' __IO_BASE_ADDRESS

`#define' `__IO_DIO_PORT'  __IO_DIO_PORT

`#define' `__IO_SYSTEM'  __IO_SYSTEM
`#define' `__IO_LED_OUTPUT'  __IO_LED_OUTPUT
`#define' `__IO_LED_STATUS'  __IO_LED_STATUS

`#define' `__IO_CF_PORT'  __IO_CF_PORT
')
