divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__HBIOS', 1) 
define(`__HBIOS_VERS', 030001)  # HBIOS VERSION 3.0.1

# Clock frequency in Hz

define(`__CPU_CLOCK', 18432000)

# Frequency of PRT0 if configured as per normal

define(`__CLOCKS_PER_SECOND', 50)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__HBIOS'
PUBLIC `__HBIOS_VERS'

PUBLIC `__CPU_CLOCK'

PUBLIC `__CLOCKS_PER_SECOND'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__HBIOS' = __HBIOS
defc `__HBIOS_VERS' = __HBIOS_VERS

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__CLOCKS_PER_SECOND' = __CLOCKS_PER_SECOND
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__HBIOS'
`#define' `__HBIOS'  __HBIOS
`#define' `__HBIOS_VERS'  __HBIOS_VERS

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__CLOCKS_PER_SECOND' __CLOCKS_PER_SECOND
')
