divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

include(`../z88dk_version.m4')
define(`__EMBEDDED_Z180', 1)

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
PUBLIC `__EMBEDDED_Z180'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__Z88DK' = __Z88DK
defc `__EMBEDDED_Z180' = __EMBEDDED_Z180
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
#undef  `__Z88DK'
#define `__Z88DK'  __Z88DK

#undef  `__EMBEDDED_Z180'
#define `__EMBEDDED_Z180'  __EMBEDDED_Z180
')
