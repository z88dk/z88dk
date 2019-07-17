divert(-1)

###############################################################
# Z80 CPU USER CONFIGURATION
# rebuild the library if changes are made
#

# Class of z80 being targeted

define(`__Z80', 0x01)

define(`__Z80_NMOS', 0x01)
define(`__Z80_CMOS', 0x02)

define(`__CPU_Z80N__', 0x01)

# CPU variant with z80n instructions
# Use Extended Opcodes

define(`__USE_Z80N_OPCODES', 0xff)

define(`__USE_Z80N_OPCODES_NEXTREG', 1)
define(`__USE_Z80N_OPCODES_MLT', 2)
define(`__USE_Z80N_OPCODES_LDIR', 4)
define(`__USE_Z80N_OPCODES_DISPLAY', 8)
define(`__USE_Z80N_OPCODES_OTHER', 16)

# Clock frequency in Hz

define(`__CPU_CLOCK', 3500000)

# This will be the clock speed expected in time-sensitive functions
# Nominal clock speed can be 3.5MHz, 7MHz, 14MHz, 28MHz

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

PUBLIC `__CPU_Z80N__'

PUBLIC `__USE_Z80N_OPCODES'

PUBLIC `__USE_Z80N_OPCODES_NEXTREG'
PUBLIC `__USE_Z80N_OPCODES_MLT'
PUBLIC `__USE_Z80N_OPCODES_LDIR'
PUBLIC `__USE_Z80N_OPCODES_DISPLAY'
PUBLIC `__USE_Z80N_OPCODES_OTHER'

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

defc `__CPU_Z80N__' = __CPU_Z80N__

defc `__USE_Z80N_OPCODES_NEXTREG' = __USE_Z80N_OPCODES_NEXTREG
defc `__USE_Z80N_OPCODES_MLT' = __USE_Z80N_OPCODES_MLT
defc `__USE_Z80N_OPCODES_LDIR' = __USE_Z80N_OPCODES_LDIR
defc `__USE_Z80N_OPCODES_DISPLAY' = __USE_Z80N_OPCODES_DISPLAY
defc `__USE_Z80N_OPCODES_OTHER' = __USE_Z80N_OPCODES_OTHER

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

`#define' `__CPU_Z80N__' __CPU_Z80N__

`#define' `__USE_Z80N_OPCODES_NEXTREG'  __USE_Z80N_OPCODES_NEXTREG
`#define' `__USE_Z80N_OPCODES_MLT'  __USE_Z80N_OPCODES_MLT
`#define' `__USE_Z80N_OPCODES_LDIR'  __USE_Z80N_OPCODES_LDIR
`#define' `__USE_Z80N_OPCODES_DISPLAY'  __USE_Z80N_OPCODES_DISPLAY
`#define' `__USE_Z80N_OPCODES_OTHER'  __USE_Z80N_OPCODES_OTHER

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__CPU_INFO'  __CPU_INFO

`#define' `__CPU_INFO_ENABLE_SLL'  __CPU_INFO_ENABLE_SLL
')
