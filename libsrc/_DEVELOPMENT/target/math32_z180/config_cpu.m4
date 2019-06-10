divert(-1)

###############################################################
# Z180 CPU CONFIGURATION
#

# Class of Z180 being targeted

define(`__Z180', 0x04)

define(`__Z180_Z80180', 0x01)
define(`__Z180_Z8L180', 0x02)
define(`__Z180_Z8S180', 0x04)

# CPU info

define(`__CPU_INFO', 0x00)

define(`__CPU_INFO_ENABLE_SLL', 0x01)

define(`__CPU_TIMER_SCALE', 20)

#
# END OF CONFIGURATION
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

PUBLIC `__CPU_INFO'

PUBLIC `__CPU_INFO_ENABLE_SLL'

PUBLIC `__CPU_TIMER_SCALE'

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

defc `__CPU_INFO' = __CPU_INFO

defc `__CPU_INFO_ENABLE_SLL' = __CPU_INFO_ENABLE_SLL

defc `__CPU_TIMER_SCALE' = __CPU_TIMER_SCALE


')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__Z180'
`#define' `__Z180'  __Z180

`#define' `__Z180_Z80180'  __Z180_Z80180
`#define' `__Z180_Z8L180'  __Z180_Z8L180
`#define' `__Z180_Z8S180'  __Z180_Z8S180

`#define' `__CPU_INFO'  __CPU_INFO

`#define' `__CPU_INFO_ENABLE_SLL'  __CPU_INFO_ENABLE_SLL

`#define' `__CPU_TIMER_SCALE'  __CPU_TIMER_SCALE


')
