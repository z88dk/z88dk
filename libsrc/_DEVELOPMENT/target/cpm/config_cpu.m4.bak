divert(-1)

###############################################################
# Z80 CPU USER CONFIGURATION
# rebuild the library if changes are made
#

# Class of z80 being targeted

define(`__Z80', 0x01)

define(`__Z80_NMOS', 0x01)
define(`__Z80_CMOS', 0x02)

# Clock frequency in Hz

define(`__CPU_CLOCK', 4000000)

# CPU info

define(`__CPU_INFO', 0x00)

define(`__CPU_INFO_ENABLE_SLL', 0x01)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__Z80'

PUBLIC `__Z80_NMOS'
PUBLIC `__Z80_CMOS'

PUBLIC `__CPU_CLOCK'

PUBLIC `__CPU_INFO'

PUBLIC `__CPU_INFO_ENABLE_SLL'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__Z80' = __Z80

defc `__Z80_NMOS' = __Z80_NMOS
defc `__Z80_CMOS' = __Z80_CMOS

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__CPU_INFO' = __CPU_INFO

defc `__CPU_INFO_ENABLE_SLL' = __CPU_INFO_ENABLE_SLL
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__Z80'
`#define' `__Z80'  __Z80

`#define' `__Z80_NMOS'  __Z80_NMOS
`#define' `__Z80_CMOS'  __Z80_CMOS

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__CPU_INFO'  __CPU_INFO

`#define' `__CPU_INFO_ENABLE_SLL'  __CPU_INFO_ENABLE_SLL
')
