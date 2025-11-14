divert(-1)

###############################################################
# REAL-TIME CLOCK USER CONFIGURATION
# rebuild the library if changes are made
#

# An optional add-on to the ZX Next is the DS-1307 real-time
# clock chip.  A datasheet is available here:
#
# https://github.com/z88dk/techdocs/blob/master/targets/zx-next/DS1307.pdf
#
# The chip is communicated with over an I2C serial bus.
# It's possible that multiple devices could be attached to
# the bus.

define(`__IO_I2C_SCL', 0x103b)
define(`__IO_I2C_SDA', 0x113b)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_I2C_SCL'
PUBLIC `__IO_I2C_SDA'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_I2C_SCL' = __IO_I2C_SCL
defc `__IO_I2C_SDA' = __IO_I2C_SDA
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_I2C_SCL'  __IO_I2C_SCL
`#define' `__IO_I2C_SDA'  __IO_I2C_SDA
')
