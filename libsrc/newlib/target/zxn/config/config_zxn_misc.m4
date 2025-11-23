divert(-1)

###############################################################
# MISCELLANEOUS CONFIG
# rebuild the library if changes are made
#

#
# DIVMMC MEMORY
# see https://velesoft.speccy.cz/zx/divide/divide-memory.htm
#

# PORT 0xE3: IO_DIVIDE_CONTROL

define(`__IO_DIVIDE_CONTROL', 0xe3)

define(`__IDC_CONMEM', 0x80)
define(`__IDC_MAPRAM', 0x40)

#
# SPI INTERFACE
# sd card, raspberry pi
#

# PORT 0xE7: SPI_CONTROL (W)

define(`__IO_SPI_CONTROL', 0xe7)

define(`__ISC_SPI_CS', 0x80)
define(`__ISC_FT_CS', 0x40)
define(`__ISC_RPI_CS1', 0x08)
define(`__ISC_RPI_CS0', 0x04)
define(`__ISC_SD_CS1', 0x02)
define(`__ISC_SD_CS0', 0x01)

define(`__IO_E7_SPI_CS', __ISC_SPI_CS)
define(`__IO_E7_FT_CS', __ISC_FT_CS)
define(`__IO_E7_RPI_CS1', __ISC_RPI_CS1)
define(`__IO_E7_RPI_CS0', __ISC_RPI_CS0)
define(`__IO_E7_SD_CS1', __ISC_SD_CS1)
define(`__IO_E7_SD_CS0', __ISC_SD_CS0)

# PORT 0xE7: SPI_STATUS (R)

define(`__IO_SPI_STATUS', 0xe7)

# PORT 0xEB: SPI_DATA

define(`__IO_SPI_DATA', 0xeb)

#
# LED
#

# PORT 0x103B: LED active low
# Not present on the zx next but used in boot programs

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
PUBLIC `__IO_DIVIDE_CONTROL'

PUBLIC `__IDC_CONMEM'
PUBLIC `__IDC_MAPRAM'

PUBLIC `__IO_SPI_CONTROL'

PUBLIC `__ISC_SPI_CS'
PUBLIC `__ISC_FT_CS'
PUBLIC `__ISC_RPI_CS1'
PUBLIC `__ISC_RPI_CS0'
PUBLIC `__ISC_SD_CS1'
PUBLIC `__ISC_SD_CS0'

PUBLIC `__IO_E7_SPI_CS'
PUBLIC `__IO_E7_FT_CS'
PUBLIC `__IO_E7_RPI_CS1'
PUBLIC `__IO_E7_RPI_CS0'
PUBLIC `__IO_E7_SD_CS1'
PUBLIC `__IO_E7_SD_CS0'

PUBLIC `__IO_SPI_STATUS'
PUBLIC `__IO_SPI_DATA'

PUBLIC `__IO_LED_L'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_DIVIDE_CONTROL' = __IO_DIVIDE_CONTROL

defc `__IDC_CONMEM' = __IDC_CONMEM
defc `__IDC_MAPRAM' = __IDC_MAPRAM

defc `__IO_SPI_CONTROL' = __IO_SPI_CONTROL

defc `__ISC_SPI_CS' = __ISC_SPI_CS
defc `__ISC_FT_CS' = __ISC_FT_CS
defc `__ISC_RPI_CS1' = __ISC_RPI_CS1
defc `__ISC_RPI_CS0' = __ISC_RPI_CS0
defc `__ISC_SD_CS1' = __ISC_SD_CS1
defc `__ISC_SD_CS0' = __ISC_SD_CS0

defc `__IO_E7_SPI_CS' = __IO_E7_SPI_CS
defc `__IO_E7_FT_CS' = __IO_E7_FT_CS
defc `__IO_E7_RPI_CS1' = __IO_E7_RPI_CS1
defc `__IO_E7_RPI_CS0' = __IO_E7_RPI_CS0
defc `__IO_E7_SD_CS1' = __IO_E7_SD_CS1
defc `__IO_E7_SD_CS0' = __IO_E7_SD_CS0

defc `__IO_SPI_STATUS' = __IO_SPI_STATUS
defc `__IO_SPI_DATA' = __IO_SPI_DATA

defc `__IO_LED_L' = __IO_LED_L
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_DIVIDE_CONTROL'  __IO_DIVIDE_CONTROL

`#define' `__IDC_CONMEM'  __IDC_CONMEM
`#define' `__IDC_MAPRAM'  __IDC_MAPRAM

`#define' `__IO_SPI_CONTROL'  __IO_SPI_CONTROL

`#define' `__ISC_SPI_CS'  __ISC_SPI_CS
`#define' `__ISC_FT_CS'  __ISC_FT_CS
`#define' `__ISC_RPI_CS1'  __ISC_RPI_CS1
`#define' `__ISC_RPI_CS0'  __ISC_RPI_CS0
`#define' `__ISC_SD_CS1'  __ISC_SD_CS1
`#define' `__ISC_SD_CS0'  __ISC_SD_CS0

`#define' `__IO_E7_SPI_CS'  __IO_E7_SPI_CS
`#define' `__IO_E7_FT_CS'  __IO_E7_FT_CS
`#define' `__IO_E7_RPI_CS1'  __IO_E7_RPI_CS1
`#define' `__IO_E7_RPI_CS0'  __IO_E7_RPI_CS0
`#define' `__IO_E7_SD_CS1'  __IO_E7_SD_CS1
`#define' `__IO_E7_SD_CS0'  __IO_E7_SD_CS0

`#define' `__IO_SPI_STATUS'  __IO_SPI_STATUS
`#define' `__IO_SPI_DATA'  __IO_SPI_DATA

`#define' `__IO_LED_L'  __IO_LED_L
')
