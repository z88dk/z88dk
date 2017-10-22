divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__RC2014', 1)

# Clock frequency in Hz

define(`__CPU_CLOCK', 7372800)

# MC68C60 ACIA Port Definitions

define(`__IO_ACIA_PORT_BASE', 0x80)   # Port Address for 68C50

# 82C55 PIO Port Definitions

define(`__IO_PIO_PORT_BASE', 0x20)    # Port Address for 82C55

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

PUBLIC `__IO_ACIA_PORT_BASE'
PUBLIC `__IO_PIO_PORT_BASE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__RC2014' = __RC2014

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__IO_ACIA_PORT_BASE' = __IO_ACIA_PORT_BASE
defc `__IO_PIO_PORT_BASE' = __IO_PIO_PORT_BASE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__RC2014'
`#define' `__RC2014'  __RC2014

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__IO_ACIA_PORT_BASE'  __IO_ACIA_PORT_BASE
`#define' `__IO_PIO_PORT_BASE'  __IO_PIO_PORT_BASE
')
