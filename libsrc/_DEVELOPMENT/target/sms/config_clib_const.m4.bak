define(`__count__', 0)
define(`__ECOUNT__', `__count__`'define(`__count__', eval(__count__+1))')

###############################################################
# C LIBRARY CONSTANTS - MESSAGES AND IOCTL

include(`../clib_const.m4')

# NO USER CONFIGURATION, MUST APPEAR FIRST
###############################################################

divert(-1)

###############################################################
# TARGET CONSTANTS - MESSAGES AND IOCTL
# rebuild the library if changes are made
#

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
')

undefine(`__count__')
undefine(`__ECOUNT__')
