divert(-1)

###############################################################
# RC2014 RAM CONFIGURATION
# rebuild the library if changes are made
#

# Pageable Memory Port Definitions

define(`__IO_RAM_SHADOW_AVAILABLE', 0x00)   # 0x01 = The Shadow RAM is available and should be used.

define(`__IO_RAM_TOGGLE', 0x30)             # Port Address for RAM Toggle
define(`__IO_ROM_TOGGLE', 0x38)             # Port Address for ROM Toggle

define(`__IO_RAM_SHADOW_BASE', 0x58)        # Base Address of Shadow Ram Stub Address
#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_RAM_TOGGLE'
PUBLIC `__IO_ROM_TOGGLE'
PUBLIC `__IO_RAM_SHADOW_BASE'

PUBLIC `__IO_RAM_SHADOW_AVAILABLE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_RAM_TOGGLE' = __IO_RAM_TOGGLE
defc `__IO_ROM_TOGGLE' = __IO_ROM_TOGGLE
defc `__IO_RAM_SHADOW_BASE'  = __IO_RAM_SHADOW_BASE

defc `__IO_RAM_SHADOW_AVAILABLE'  = __IO_RAM_SHADOW_AVAILABLE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_RAM_TOGGLE'  __IO_RAM_TOGGLE
`#define' `__IO_ROM_TOGGLE'  __IO_ROM_TOGGLE
`#define' `__IO_RAM_SHADOW_BASE'  __IO_RAM_SHADOW_BASE

`#define' `__IO_RAM_SHADOW_AVAILABLE'  __IO_RAM_SHADOW_AVAILABLE
')
