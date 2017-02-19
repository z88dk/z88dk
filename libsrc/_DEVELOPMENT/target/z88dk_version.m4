divert(-1)

###############################################################
# Generate Z88DK version string
# rebuild all libraries if changes are made
#

# Version 1.99C, A=0 B=1 C=2

define(`__Z88DK', 1992)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__Z88DK'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__Z88DK' = __Z88DK
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__Z88DK'
`#define' `__Z88DK'  __Z88DK
')
