divert(-1)

###############################################################
# NASCOM BASIC CONFIGURATION
#

# RAM Vector Address for Z80 RST Table, and for Z180 Vector Table
# Defined for NASCOM BASIC subtypes

define(`__Z80_VECTOR_BASE_BASIC', 0x2000) # YAZ180 BASIC 56KB
define(`__Z180_VECTOR_IL_BASIC',  0x40)   # Vector Base address (IL)
                                          # [001x xxxx] for Vectors at $nn40 - $nn5F
#
# END OF CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__Z80_VECTOR_BASE_BASIC'
PUBLIC `__Z180_VECTOR_IL_BASIC'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__Z80_VECTOR_BASE_BASIC' = __Z80_VECTOR_BASE_BASIC
defc `__Z180_VECTOR_IL_BASIC' = __Z180_VECTOR_IL_BASIC
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__Z80_VECTOR_BASE_BASIC'  __Z80_VECTOR_BASE_BASIC
`#define' `__Z180_VECTOR_IL_BASIC'  __Z180_VECTOR_IL_BASIC
')
