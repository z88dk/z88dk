divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Am9511A APU Definitions

define(`__IO_APU_PORT_BASE', 0x42)  # Port Address for Am9511A Module

# Am9511A APU Multi Processor Definitions

define(`__IO_APU0_PORT_BASE', 0x42) # Base Address for Am9511A Module #0
define(`__IO_APU1_PORT_BASE', 0x62) # Base Address for Am9511A Module #1
define(`__IO_APU2_PORT_BASE', 0xC2) # Base Address for Am9511A Module #2
define(`__IO_APU3_PORT_BASE', 0xE2) # Base Address for Am9511A Module #3

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_APU_PORT_BASE'

PUBLIC `__IO_APU0_PORT_BASE'
PUBLIC `__IO_APU1_PORT_BASE'
PUBLIC `__IO_APU2_PORT_BASE'
PUBLIC `__IO_APU3_PORT_BASE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_APU_PORT_BASE' = __IO_APU_PORT_BASE

defc `__IO_APU0_PORT_BASE' = __IO_APU0_PORT_BASE
defc `__IO_APU1_PORT_BASE' = __IO_APU1_PORT_BASE
defc `__IO_APU2_PORT_BASE' = __IO_APU2_PORT_BASE
defc `__IO_APU3_PORT_BASE' = __IO_APU3_PORT_BASE
')

