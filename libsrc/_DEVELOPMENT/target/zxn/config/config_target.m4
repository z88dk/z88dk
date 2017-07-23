divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

define(`__ZXNEXT', 1)

# Compatible Spectrum model

define(`__SPECTRUM', 2)

define(`__SPECTRUM_48', 1)
define(`__SPECTRUM_128', 2)
define(`__SPECTRUM_128_P2', 4)
define(`__SPECTRUM_128_P2A', 8)
define(`__SPECTRUM_128_P3', 16)
define(`__SPECTRUM_PENTAGON', 32)

# Second display file

define(`__USE_SPECTRUM_128_SECOND_DFILE', 0)

# TBBLUE I/O Port System for the Spectrum Next

define(`__IO_REGISTRY_REG', 0x253b)
define(`__IO_REGISTRY_DAT', 0x243b)

define(`__IO_REGISTRY_REG_MACHINE_ID',                       0)
define(`__IO_REGISTRY_REG_VERSION',                          1)
define(`__IO_REGISTRY_REG_RESET',                            2)
define(`__IO_REGISTRY_REG_MACHINE_TYPE',                     3)
define(`__IO_REGISTRY_REG_PAGE_RAM',                         4)
define(`__IO_REGISTRY_REG_PERIPHERAL_1',                     5)
define(`__IO_REGISTRY_REG_PERIPHERAL_2',                     6)
define(`__IO_REGISTRY_REG_TURBO_MODE',                       7)
define(`__IO_REGISTRY_REG_PERIPHERAL_3',                     8)
define(`__IO_REGISTRY_REG_ANTI_BRICK',                      10)
define(`__IO_REGISTRY_REG_LAYER_2_RAM_PAGE',                19)
define(`__IO_REGISTRY_REG_LAYER_2_TRANSPARENCY_COLOR',      20)
define(`__IO_REGISTRY_REG_LAYER_PRIORITY',                  21)
define(`__IO_REGISTRY_REG_SPRITE_SYSTEM',                   21)
define(`__IO_REGISTRY_REG_LAYER_2_SCROLL_X',                22)
define(`__IO_REGISTRY_REG_LAYER_2_SCROLL_Y',                23)
define(`__IO_REGISTRY_REG_RASTER_LINE_MSB',                 30)
define(`__IO_REGISTRY_REG_RASTER_LINE_LSB',                 31)
define(`__IO_REGISTRY_REG_RASTER_LINE_INTERRUPT_CONTROL',   34)
define(`__IO_REGISTRY_REG_RASTER_LINE_INTERRUPT_VALUE_LSB', 35)
define(`__IO_REGISTRY_REG_KEYMAP_ADDRESS_MSB',              40)
define(`__IO_REGISTRY_REG_KEYMAP_ADDRESS_LSB',              41)
define(`__IO_REGISTRY_REG_KEYMAP_DATA_MSB',                 42)
define(`__IO_REGISTRY_REG_KEYMAP_DATA_LSB',                 43)
define(`__IO_REGISTRY_REG_DEBUG_LEDS',                    0xff)

# Hardware Sprites

define(`__IO_SPRITE_SYSTEM_FLAGS',            0x303b)
define(`__IO_SPRITE_PALETTE',                   0x53)
define(`__IO_SPRITE_ATTRIBUTE',                 0x57)
define(`__IO_SPRITE_PATTERN',                   0x5b)

define(`__SPRITE_TRANSPARENT_COLOR',            0xe3)

define(`__IO_SPRITE_SYSTEM_FLAGS_MAX_PER_LINE', 0x02)
define(`__IO_SPRITE_SYSTEM_FLAGS_COLLISION',    0x01)

# Audio

define(`__IO_AUDIO_SELECT',            0xfffd)
define(`__IO_AUDIO_REG',               0xfffd)
define(`__IO_AUDIO_DAT',               0xbffd)

define(`__IO_AUDIO_SELECT_LEFT_ENABLE',  0xdc)
define(`__IO_AUDIO_SELECT_RIGHT_ENABLE', 0xbc)
define(`__IO_AUDIO_SELECT_PSG_1',        0x9f)
define(`__IO_AUDIO_SELECT_PSG_2',        0x9e)
define(`__IO_AUDIO_SELECT_PSG_3',        0x9d)
define(`__IO_AUDIO_SELECT_SID',          0x9c)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__ZXNEXT'

PUBLIC `__SPECTRUM'

PUBLIC `__SPECTRUM_48'
PUBLIC `__SPECTRUM_128'
PUBLIC `__SPECTRUM_128_P2'
PUBLIC `__SPECTRUM_128_P2A'
PUBLIC `__SPECTRUM_128_P3'
PUBLIC `__SPECTRUM_PENTAGON'

PUBLIC `__USE_SPECTRUM_128_SECOND_DFILE'
















')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__ZXNEXT'            = __ZXNEXT

defc `__SPECTRUM'          = __SPECTRUM

defc `__SPECTRUM_48'       = __SPECTRUM_48
defc `__SPECTRUM_128'      = __SPECTRUM_128
defc `__SPECTRUM_128_P2'   = __SPECTRUM_128_P2
defc `__SPECTRUM_128_P2A'  = __SPECTRUM_128_P2A
defc `__SPECTRUM_128_P3'   = __SPECTRUM_128_P3
defc `__SPECTRUM_PENTAGON' = __SPECTRUM_PENTAGON

defc `__USE_SPECTRUM_128_SECOND_DFILE' = __USE_SPECTRUM_128_SECOND_DFILE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__ZXNEXT'
`#define' `__ZXNEXT'    __ZXNEXT

`#undef'  `__SPECTRUM'
`#define' `__SPECTRUM'  __SPECTRUM

`#define' `__SPECTRUM_48'        __SPECTRUM_48
`#define' `__SPECTRUM_128'       __SPECTRUM_128
`#define' `__SPECTRUM_128_P2'    __SPECTRUM_128_P2
`#define' `__SPECTRUM_128_P2A'   __SPECTRUM_128_P2A
`#define' `__SPECTRUM_128_P3'    __SPECTRUM_128_P3
`#define' `__SPECTRUM_PENTAGON'  __SPECTRUM_PENTAGON

`#define' `__USE_SPECTRUM_128_SECOND_DFILE'  __USE_SPECTRUM_128_SECOND_DFILE
')
