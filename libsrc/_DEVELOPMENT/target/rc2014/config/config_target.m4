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

define(`__IO_DIO_PORT', 0x00)    # Port Address for DIO

# Compact Flash Module Port Definition

define(`__IO_CF_PORT', 0x10)    # Port Address for CF

# 82C55 PIO Port Definitions

define(`__IO_PIO_PORT_BASE', 0x20)    # Port Address for 82C55

# Pageable ROM Port Definitions

define(`__IO_PROM_RESET', 0x30)   # Port Address for PROM Reset
define(`__IO_PROM_TOGGLE', 0x38)   # Port Address for PROM Toggle

# MC68C60 ACIA Port Definitions

define(`__IO_ACIA_PORT_BASE', 0x80)   # Port Address for 68C50

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
PUBLIC `__IO_ACIA_PORT_BASE'
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
defc `__IO_ACIA_PORT_BASE' = __IO_ACIA_PORT_BASE
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
`#define' `__IO_ACIA_PORT_BASE'  __IO_ACIA_PORT_BASE
')
