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

define(`__IO_CF_PORT', 0x10)    # Port Address for CF Module

# 82C55 PIO Port Definition

define(`__IO_PIO_PORT_BASE', 0x20)  # Port Address for 82C55 Module

# Pageable ROM Port Definitions

define(`__IO_PROM_RESET', 0x30)     # Port Address for PROM Reset
define(`__IO_PROM_TOGGLE', 0x38)    # Port Address for PROM Toggle

# LUT Module Port Definition

define(`__IO_LUT_PORT_BASE', 0x40)  # Port Address for LUT Module

# Am9511A-1 APU Definitions

define(`__IO_APU_PORT_BASE', 0x42)  # Port Address for Am9511A Module

# MC68C60 ACIA Port Definition

define(`__IO_ACIA_PORT_BASE', 0x80) # Port Address for 68C50 Module

# Zilog SIO Port Definitions

define(`__IO_SIO_PORT_BASE', 0x80)  # Port Address for SIO/0-2 Module

# Spencer's build
define(`__IO_SIO_PORT_OFFSET_A', 0x00)  # Port Offset for A Channel (A1)
define(`__IO_SIO_PORT_OFFSET_B', 0x02)  # Port Offset for B Channel (A1)
define(`__IO_SIO_PORT_OFFSET_C', 0x00)  # Port Offset for Command (!A0)
define(`__IO_SIO_PORT_OFFSET_D', 0x01)  # Port Offset for Data (!A0)

# Standard (including Dr Baker)
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

PUBLIC `__CPU_CLOCK'

PUBLIC `__IO_DIO_PORT'
PUBLIC `__IO_CF_PORT'
PUBLIC `__IO_PIO_PORT_BASE'
PUBLIC `__IO_PROM_RESET'
PUBLIC `__IO_PROM_TOGGLE'
PUBLIC `__IO_LUT_PORT_BASE'
PUBLIC `__IO_APU_PORT_BASE'
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
defc `__IO_CF_PORT' = __IO_CF_PORT
defc `__IO_PIO_PORT_BASE' = __IO_PIO_PORT_BASE
defc `__IO_PROM_RESET' = __IO_PROM_RESET
defc `__IO_PROM_TOGGLE' = __IO_PROM_TOGGLE
defc `__IO_LUT_PORT_BASE' = __IO_LUT_PORT_BASE
defc `__IO_APU_PORT_BASE' = __IO_APU_PORT_BASE
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

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__IO_DIO_PORT'  __IO_DIO_PORT
`#define' `__IO_CF_PORT'  __IO_CF_PORT
`#define' `__IO_PIO_PORT_BASE'  __IO_PIO_PORT_BASE
`#define' `__IO_PROM_RESET'  __IO_PROM_RESET
`#define' `__IO_PROM_TOGGLE'  __IO_PROM_TOGGLE
')
