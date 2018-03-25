divert(-1)

###############################################################
# MISCELLANEOUS CONFIG
# rebuild the library if changes are made
#

#
# SD CARD PORTS
#

# PORT 0xE7: SD_CONTROL (W)

define(`__IO_SD_CONTROL', 0xe7)

# PORT 0xE7: SD_STATUS (R)

define(`__IO_SD_STATUS', 0xe7)

# PORT 0xEB: SD_DATA

define(`__IO_SD_DATA', 0xeb)

#
# LED
#

# PORT 0x103B: LED active low

define(`__IO_LED_L', 0x103b)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_SD_CONTROL'
PUBLIC `__IO_SD_STATUS'
PUBLIC `__IO_SD_DATA'

PUBLIC `__IO_LED_L'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_SD_CONTROL' = __IO_SD_CONTROL
defc `__IO_SD_STATUS' = __IO_SD_STATUS
defc `__IO_SD_DATA' = __IO_SD_DATA

defc `__IO_LED_L' = __IO_LED_L
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_SD_CONTROL'  __IO_SD_CONTROL
`#define' `__IO_SD_STATUS'  __IO_SD_STATUS
`#define' `__IO_SD_DATA'  __IO_SD_DATA

`#define' `__IO_LED_L'  __IO_LED_L
')
