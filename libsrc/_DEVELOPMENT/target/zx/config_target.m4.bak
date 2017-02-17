divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Spectrum model

define(`__SPECTRUM', 1)

define(`__SPECTRUM_48', 1)
define(`__SPECTRUM_128', 2)
define(`__SPECTRUM_128_P2', 4)
define(`__SPECTRUM_128_P2A', 8)
define(`__SPECTRUM_128_P3', 16)
define(`__SPECTRUM_PENTAGON', 32)

define(`__SPECTRUM_128_MASK', 62)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__SPECTRUM'

PUBLIC `__SPECTRUM_48'
PUBLIC `__SPECTRUM_128'
PUBLIC `__SPECTRUM_128_P2'
PUBLIC `__SPECTRUM_128_P2A'
PUBLIC `__SPECTRUM_128_P3'
PUBLIC `__SPECTRUM_PENTAGON'

PUBLIC `__SPECTRUM_128_MASK'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__SPECTRUM'          = __SPECTRUM

defc `__SPECTRUM_48'       = __SPECTRUM_48
defc `__SPECTRUM_128'      = __SPECTRUM_128
defc `__SPECTRUM_128_P2'   = __SPECTRUM_128_P2
defc `__SPECTRUM_128_P2A'  = __SPECTRUM_128_P2A
defc `__SPECTRUM_128_P3'   = __SPECTRUM_128_P3
defc `__SPECTRUM_PENTAGON' = __SPECTRUM_PENTAGON

defc `__SPECTRUM_128_MASK' = __SPECTRUM_128_MASK
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__SPECTRUM'
`#define' `__SPECTRUM'  __SPECTRUM

`#define' `__SPECTRUM_48'        __SPECTRUM_48
`#define' `__SPECTRUM_128'       __SPECTRUM_128
`#define' `__SPECTRUM_128_P2'    __SPECTRUM_128_P2
`#define' `__SPECTRUM_128_P2A'   __SPECTRUM_128_P2A
`#define' `__SPECTRUM_128_P3'    __SPECTRUM_128_P3
`#define' `__SPECTRUM_PENTAGON'  __SPECTRUM_PENTAGON

`#define' `__SPECTRUM_128_MASK'  __SPECTRUM_128_MASK
')
