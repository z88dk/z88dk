divert(-1)

###############################################################
# SOUND/BIT USER CONFIGURATION
# rebuild the library if changes are made
#

# ONE-BIT SOUND CONSTANTS

define(`__SOUND_BIT_METHOD',     1)      # 1 = port_8, 2 = port_16, 3 = memory
define(`__SOUND_BIT_PORT',       0xfe)   # port or memory address
define(`__SOUND_BIT_TOGGLE',     0x10)   # bits to toggle to make noise
define(`__SOUND_BIT_TOGGLE_POS', 4)      # bit position to test state of output
define(`__SOUND_BIT_READ_MASK',  0x17)   # part of state byte to be used in output
define(`__SOUND_BIT_WRITE_MASK', 0xe8)   # part of state byte to be preserved on write

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__SOUND_BIT_METHOD'
PUBLIC `__SOUND_BIT_PORT'
PUBLIC `__SOUND_BIT_TOGGLE'
PUBLIC `__SOUND_BIT_TOGGLE_POS'
PUBLIC `__SOUND_BIT_READ_MASK'
PUBLIC `__SOUND_BIT_WRITE_MASK'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__SOUND_BIT_METHOD'     =  __SOUND_BIT_METHOD
defc `__SOUND_BIT_PORT'       =  __SOUND_BIT_PORT
defc `__SOUND_BIT_TOGGLE'     =  __SOUND_BIT_TOGGLE
defc `__SOUND_BIT_TOGGLE_POS' =  __SOUND_BIT_TOGGLE_POS
defc `__SOUND_BIT_READ_MASK'  =  __SOUND_BIT_READ_MASK
defc `__SOUND_BIT_WRITE_MASK' =  __SOUND_BIT_WRITE_MASK
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__SOUND_BIT_METHOD'      __SOUND_BIT_METHOD
`#define' `__SOUND_BIT_PORT'        __SOUND_BIT_PORT
`#define' `__SOUND_BIT_TOGGLE'      __SOUND_BIT_TOGGLE
`#define' `__SOUND_BIT_TOGGLE_POS'  __SOUND_BIT_TOGGLE_POS
`#define' `__SOUND_BIT_READ_MASK'   __SOUND_BIT_READ_MASK
`#define' `__SOUND_BIT_WRITE_MASK'  __SOUND_BIT_WRITE_MASK
')
