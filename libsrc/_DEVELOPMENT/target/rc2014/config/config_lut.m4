divert(-1)

###############################################################
# RC2014 LUT CONFIGURATION
# rebuild the library if changes are made
#

define(`__IO_LUT_OPERAND_LATCH', 0x`'eval(__IO_LUT_PORT_BASE+0x02,16))  # Address of Operand Latch
define(`__IO_LUT_RESULT_MSB', 0x`'eval(__IO_LUT_PORT_BASE+0x01,16))     # Address of Result MSB
define(`__IO_LUT_RESULT_LSB', 0x`'eval(__IO_LUT_PORT_BASE+0x00,16))     # Address of Result LSB

define(`__IO_LUT_MODULE_AVAILABLE', 0x00)   # The LUT Module is available and should be used.

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_LUT_OPERAND_LATCH'
PUBLIC `__IO_LUT_RESULT_MSB'
PUBLIC `__IO_ACIA_DATA_REGISTER'

PUBLIC `__IO_LUT_MODULE_AVAILABLE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_LUT_OPERAND_LATCH'  = __IO_LUT_OPERAND_LATCH
defc `__IO_LUT_RESULT_MSB'  = __IO_LUT_RESULT_MSB
defc `__IO_LUT_RESULT_LSB'  = __IO_LUT_RESULT_LSB

defc `__IO_LUT_MODULE_AVAILABLE'  = __IO_LUT_MODULE_AVAILABLE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_LUT_OPERAND_LATCH'  __IO_LUT_OPERAND_LATCH
`#define' `__IO_LUT_RESULT_MSB'  __IO_LUT_RESULT_MSB
`#define' `__IO_LUT_RESULT_LSB'  __IO_LUT_RESULT_LSB

`#define' `__IO_LUT_MODULE_AVAILABLE'  __IO_LUT_MODULE_AVAILABLE
')
