divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__SMS', 1)

# I/O Ports

define(`__IO_MEMORY_ENABLES',        0x3e)
define(`__IO_JOYSTICK_PORT_CONTROL', 0x3f)
define(`__IO_GUN_SPOT_VERTICAL',     0x7e)
define(`__IO_GUN_SPOT_HORIZONTAL',   0x7f)
define(`__IO_PSG',                   0x7f)
define(`__IO_VDP_DATA',              0xbe)
define(`__IO_VDP_COMMAND',           0xbf)
define(`__IO_VDP_STATUS',            0xbf)
define(`__IO_JOYSTICK_READ_L',       0xdc)
define(`__IO_JOYSTICK_READ_H',       0xdd)

# Memory Control Registers

define(`__MM_FRAME_2_CONTROL',        0xffff)
define(`__MM_FRAME_1_CONTROL',        0xfffe)
define(`__MM_FRAME_0_CONTROL',        0xfffd)
define(`__MM_FRAME_2_RAM_CONTROL',    0xfffc)

# VRAM Address Settings (VRAM size is 16k)

define(`__SMS_VRAM_SCREEN_MAP_ADDRESS',  0x3800)              # multiples of 0x0800
define(`__SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS', 0x3f00)   # multiples of 0x0100
define(`__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS', 0x2000)      # 0x0000 or 0x2000

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__SMS'

PUBLIC `__IO_MEMORY_ENABLES'
PUBLIC `__IO_JOYSTICK_PORT_CONTROL'
PUBLIC `__IO_GUN_SPOT_VERTICAL'
PUBLIC `__IO_GUN_SPOT_HORIZONTAL'
PUBLIC `__IO_PSG'
PUBLIC `__IO_VDP_DATA'
PUBLIC `__IO_VDP_COMMAND'
PUBLIC `__IO_VDP_STATUS'
PUBLIC `__IO_JOYSTICK_READ_L'
PUBLIC `__IO_JOYSTICK_READ_H'

PUBLIC `__MM_FRAME_2_CONTROL'
PUBLIC `__MM_FRAME_1_CONTROL'
PUBLIC `__MM_FRAME_0_CONTROL'
PUBLIC `__MM_FRAME_2_RAM_CONTROL'

PUBLIC `__SMS_VRAM_SCREEN_MAP_ADDRESS'
PUBLIC `__SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS'
PUBLIC `__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__SMS' = __SMS

defc `__IO_MEMORY_ENABLES'        = __IO_MEMORY_ENABLES
defc `__IO_JOYSTICK_PORT_CONTROL' = __IO_JOYSTICK_PORT_CONTROL
defc `__IO_GUN_SPOT_VERTICAL'     = __IO_GUN_SPOT_VERTICAL
defc `__IO_GUN_SPOT_HORIZONTAL'   = __IO_GUN_SPOT_HORIZONTAL
defc `__IO_PSG'                   = __IO_PSG
defc `__IO_VDP_DATA'              = __IO_VDP_DATA
defc `__IO_VDP_COMMAND'           = __IO_VDP_COMMAND
defc `__IO_VDP_STATUS'            = __IO_VDP_STATUS
defc `__IO_JOYSTICK_READ_L'       = __IO_JOYSTICK_READ_L
defc `__IO_JOYSTICK_READ_H'       = __IO_JOYSTICK_READ_H

defc `__MM_FRAME_2_CONTROL'     = __MM_FRAME_2_CONTROL
defc `__MM_FRAME_1_CONTROL'     = __MM_FRAME_1_CONTROL
defc `__MM_FRAME_0_CONTROL'     = __MM_FRAME_0_CONTROL
defc `__MM_FRAME_2_RAM_CONTROL' = __MM_FRAME_2_RAM_CONTROL

defc `__SMS_VRAM_SCREEN_MAP_ADDRESS'             = __SMS_VRAM_SCREEN_MAP_ADDRESS
defc `__SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS' = __SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS
defc `__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS'    = __SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__SMS'
`#define' `__SMS'  __SMS

`#define' `__IO_MEMORY_ENABLES'         __IO_MEMORY_ENABLES
`#define' `__IO_JOYSTICK_PORT_CONTROL'  __IO_JOYSTICK_PORT_CONTROL
`#define' `__IO_GUN_SPOT_VERTICAL'      __IO_GUN_SPOT_VERTICAL
`#define' `__IO_GUN_SPOT_HORIZONTAL'    __IO_GUN_SPOT_HORIZONTAL
`#define' `__IO_PSG'                    __IO_PSG
`#define' `__IO_VDP_DATA'               __IO_VDP_DATA
`#define' `__IO_VDP_COMMAND'            __IO_VDP_COMMAND
`#define' `__IO_VDP_STATUS'             __IO_VDP_STATUS
`#define' `__IO_JOYSTICK_READ_L'        __IO_JOYSTICK_READ_L
`#define' `__IO_JOYSTICK_READ_H'        __IO_JOYSTICK_READ_H

`#define' `__MM_FRAME_2_CONTROL'      __MM_FRAME_2_CONTROL
`#define' `__MM_FRAME_1_CONTROL'      __MM_FRAME_1_CONTROL
`#define' `__MM_FRAME_0_CONTROL'      __MM_FRAME_0_CONTROL
`#define' `__MM_FRAME_2_RAM_CONTROL'  __MM_FRAME_2_RAM_CONTROL

`#define' `__SMS_VRAM_SCREEN_MAP_ADDRESS'              __SMS_VRAM_SCREEN_MAP_ADDRESS
`#define' `__SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS'  __SMS_VRAM_SPRITE_ATTRIBUTE_TABLE_ADDRESS
`#define' `__SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS'     __SMS_VRAM_SPRITE_PATTERN_BASE_ADDRESS
')
