divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__RC2014', 1)

# Clock frequency in Hz

define(`__CPU_CLOCK', 7372800)

# Digital I/O Module Port Definition

define(`__IO_DIO_PORT', 0x00)    # Port Address for DIO Module

# Compact Flash Module Port Definition

define(`__IO_CF_8_BIT', 0x01)       # Use 8-bit mode for CF Module (0x01)
define(`__IO_CF_PORT_BASE', 0x10)   # Port Address for CF Module

# 82C55 PIO Port Definition

define(`__IO_PIO_PORT_BASE', 0x20)  # Port Address for 82C55 Module

# MC68B50 ACIA Port Definition

define(`__IO_ACIA_PORT_BASE', 0x80) # Port Address for 68B50 Module

# Zilog SIO Port Definitions

define(`__IO_SIO_PORT_BASE', 0x80)  # Port Address for SIO/2 Module

# Spencer's SIO/2 Configuration

define(`__IO_SIO_PORT_OFFSET_A', 0x00)  # Port Offset for A Channel (A1)
define(`__IO_SIO_PORT_OFFSET_B', 0x02)  # Port Offset for B Channel (A1)
define(`__IO_SIO_PORT_OFFSET_C', 0x00)  # Port Offset for Command (!A0)
define(`__IO_SIO_PORT_OFFSET_D', 0x01)  # Port Offset for Data (!A0)

# Standard SIO/2 Configuration (including Dr Baker)

# define(`__IO_SIO_PORT_OFFSET_A', 0x00)  # Port Offset for A Channel (A0)
# define(`__IO_SIO_PORT_OFFSET_B', 0x01)  # Port Offset for B Channel (A0)
# define(`__IO_SIO_PORT_OFFSET_C', 0x02)  # Port Offset for Command (A1)
# define(`__IO_SIO_PORT_OFFSET_D', 0x00)  # Port Offset for Data (A1)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__RC2014'

PUBLIC `__IO_DIO_PORT'
PUBLIC `__IO_CF_8_BIT'
PUBLIC `__IO_CF_PORT_BASE'
PUBLIC `__IO_PIO_PORT_BASE'
PUBLIC `__IO_ACIA_PORT_BASE'
PUBLIC `__IO_SIO_PORT_BASE'
PUBLIC `__IO_SIO_PORT_OFFSET_A'
PUBLIC `__IO_SIO_PORT_OFFSET_B'
PUBLIC `__IO_SIO_PORT_OFFSET_C'
PUBLIC `__IO_SIO_PORT_OFFSET_D'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__RC2014' = __RC2014

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__IO_DIO_PORT' = __IO_DIO_PORT
defc `__IO_CF_8_BIT' = __IO_CF_8_BIT
defc `__IO_CF_PORT_BASE' = __IO_CF_PORT_BASE
defc `__IO_PIO_PORT_BASE' = __IO_PIO_PORT_BASE
defc `__IO_ACIA_PORT_BASE' = __IO_ACIA_PORT_BASE
defc `__IO_SIO_PORT_BASE' = __IO_SIO_PORT_BASE
defc `__IO_SIO_PORT_OFFSET_A' = __IO_SIO_PORT_OFFSET_A
defc `__IO_SIO_PORT_OFFSET_B' = __IO_SIO_PORT_OFFSET_B
defc `__IO_SIO_PORT_OFFSET_C' = __IO_SIO_PORT_OFFSET_C
defc `__IO_SIO_PORT_OFFSET_D' = __IO_SIO_PORT_OFFSET_D
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__RC2014'
`#define' `__RC2014'  __RC2014

`#define' `__IO_DIO_PORT'  __IO_DIO_PORT
`#define' `__IO_CF_8_BIT'  __IO_CF_8_BIT
`#define' `__IO_CF_PORT_BASE'  __IO_CF_PORT_BASE
`#define' `__IO_PIO_PORT_BASE'  __IO_PIO_PORT_BASE
')
