divert(-1)

###############################################################
# Z180 CPU USER CONFIGURATION
# rebuild the library if changes are made
#

# Class of Z180 being targeted

define(`__Z180', 0x01)

define(`__Z180_Z80180', 0x01)
define(`__Z180_Z8L180', 0x02)
define(`__Z180_Z8S180', 0x04)

# Clock frequency in Hz

define(`__CPU_CLOCK', 33000000)

# CPU info

define(`__CPU_INFO', 0x00)

define(`__CPU_INFO_NMOS', 0x01)
define(`__CPU_INFO_ENABLE_SLL', 0x02)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__Z180'

PUBLIC `__Z180_Z80180'
PUBLIC `__Z180_Z8L180'
PUBLIC `__Z180_Z8S180'

PUBLIC `__CPU_CLOCK'

PUBLIC `__CPU_INFO'

PUBLIC `__CPU_INFO_NMOS'
PUBLIC `__CPU_INFO_ENABLE_SLL'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__Z180' = __Z180

defc `__Z180_Z80180' = __Z180_Z80180
defc `__Z180_Z8L180' = __Z180_Z8L180
defc `__Z180_Z8S180' = __Z180_Z8S180

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__CPU_INFO' = __CPU_INFO

defc `__CPU_INFO_NMOS' = __CPU_INFO_NMOS
defc `__CPU_INFO_ENABLE_SLL' = __CPU_INFO_ENABLE_SLL
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
#define `__Z180'  __Z180

#define `__Z180_Z80180'  __Z180_Z80180
#define `__Z180_Z8L180'  __Z180_Z8L180
#define `__Z180_Z8S180'  __Z180_Z8S180

#define `__CPU_CLOCK'  __CPU_CLOCK

#define `__CPU_INFO'  __CPU_INFO

#define `__CPU_INFO_NMOS'  __CPU_INFO_NMOS
#define `__CPU_INFO_ENABLE_SLL'  __CPU_INFO_ENABLE_SLL
')
