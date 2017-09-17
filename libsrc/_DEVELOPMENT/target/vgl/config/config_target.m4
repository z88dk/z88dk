divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__VGL', 1)

define(`__VGL1000', 1000)
define(`__VGL2000', 2000)
define(`__VGL3000', 3000)
define(`__VGL4000', 4000)
define(`__VGL4004QXL', 4004)
define(`__VGL5000', 5000)
define(`__VGL5005', 5005)
define(`__VGL6000SL', 6000)
define(`__VGL7007', 7007)
define(`__VGL8008CX', 8008)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__VGL'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__VGL' = __VGL
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__VGL'
`#define' `__VGL'  __VGL
')
