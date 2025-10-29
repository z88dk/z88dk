divert(-1)

###############################################################
# BIFROST_H MULTICOLOUR ENGINE CONFIGURATION
# rebuild the library if changes are made
#

# Animation speed: 2 or 4 frames per second
define(`__BIFROSTH_ANIM_SPEED', 4)

# Animation size: 2 or 4 frames per animation group
define(`__BIFROSTH_ANIM_GROUP', 4)

# First non-animated frame
define(`__BIFROSTH_STATIC_MIN', 128)

# Value subtracted from non-animated frames
define(`__BIFROSTH_STATIC_OVERLAP', 128)

# Default location of multicolor tiles table (16x16 pixels, 64 bytes per tile)
define(`__BIFROSTH_TILE_IMAGES', 48500)

# Location of the tile map (9x9=81 tiles)
define(`__BIFROSTH_TILE_MAP', 65281)

# Tile rendering order (1 for sequential, 7 for distributed)
define(`__BIFROSTH_TILE_ORDER', 7)

# Shift screen coordinates by 0 or 4 columns to the right
define(`__BIFROSTH_SHIFT_COLUMNS', 0)

# Render special sprite tiles every frame?
define(`__BIFROSTH_SPRITE_MODE', 0)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__BIFROSTH_ANIM_SPEED'
PUBLIC `__BIFROSTH_ANIM_GROUP'
PUBLIC `__BIFROSTH_STATIC_MIN'
PUBLIC `__BIFROSTH_STATIC_OVERLAP'
PUBLIC `__BIFROSTH_TILE_IMAGES'
PUBLIC `__BIFROSTH_TILE_MAP'
PUBLIC `__BIFROSTH_TILE_ORDER'
PUBLIC `__BIFROSTH_SHIFT_COLUMNS'
PUBLIC `__BIFROSTH_SPRITE_MODE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__BIFROSTH_ANIM_SPEED'     = __BIFROSTH_ANIM_SPEED
defc `__BIFROSTH_ANIM_GROUP'     = __BIFROSTH_ANIM_GROUP
defc `__BIFROSTH_STATIC_MIN'     = __BIFROSTH_STATIC_MIN
defc `__BIFROSTH_STATIC_OVERLAP' = __BIFROSTH_STATIC_OVERLAP
defc `__BIFROSTH_TILE_IMAGES'    = __BIFROSTH_TILE_IMAGES
defc `__BIFROSTH_TILE_MAP'       = __BIFROSTH_TILE_MAP
defc `__BIFROSTH_TILE_ORDER'     = __BIFROSTH_TILE_ORDER
defc `__BIFROSTH_SHIFT_COLUMNS'  = __BIFROSTH_SHIFT_COLUMNS
defc `__BIFROSTH_SPRITE_MODE'    = __BIFROSTH_SPRITE_MODE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__BIFROSTH_ANIM_SPEED'      __BIFROSTH_ANIM_SPEED
`#define' `__BIFROSTH_ANIM_GROUP'      __BIFROSTH_ANIM_GROUP
`#define' `__BIFROSTH_STATIC_MIN'      __BIFROSTH_STATIC_MIN
`#define' `__BIFROSTH_STATIC_OVERLAP'  __BIFROSTH_STATIC_OVERLAP
`#define' `__BIFROSTH_TILE_IMAGES'     __BIFROSTH_TILE_IMAGES
`#define' `__BIFROSTH_TILE_MAP'        __BIFROSTH_TILE_MAP
`#define' `__BIFROSTH_TILE_ORDER'      __BIFROSTH_TILE_ORDER
`#define' `__BIFROSTH_SHIFT_COLUMNS'   __BIFROSTH_SHIFT_COLUMNS
`#define' `__BIFROSTH_SPRITE_MODE'     __BIFROSTH_SPRITE_MODE
')
