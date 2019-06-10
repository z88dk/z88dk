divert(-1)

###############################################################
# M32 LIBRARY USER CONFIGURATION
# rebuild the library if changes are made
#

; This option affects how multiplications and divisions
; performed by the compiler and the library.

; NOTE THIS IS ONLY RELEVANT FOR Z80 CPU (NOT Z180 & Z80-ZXN)

; Setting the value of this flag appropriately allows
; selection of an integer math lib that ranges from
; fast and big to slow and small.

define(`__CLIB_OPT_FMATH', 0)

; < 50 = select unrolled mulu_de math library
; > 50 = select table mulu_de math library

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__CLIB_OPT_FMATH'

')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__CLIB_OPT_FMATH' = __CLIB_OPT_FMATH

')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__CLIB_OPT_FMATH'  __CLIB_OPT_FMATH

')
