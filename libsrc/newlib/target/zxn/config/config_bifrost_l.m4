divert(-1)

###############################################################
# BIFROST_L MULTICOLOUR ENGINE CONFIGURATION
# rebuild the library if changes are made
#

# Animation speed: 2 or 4 frames per second
define(`__BIFROSTL_ANIM_SPEED', 4)

# Animation size: 2 or 4 frames per animation group
define(`__BIFROSTL_ANIM_GROUP', 4)

# First non-animated frame
define(`__BIFROSTL_STATIC_MIN', 128)

# Value subtracted from non-animated frames
define(`__BIFROSTL_STATIC_OVERLAP', 128)

# Default location of multicolor tiles table (16x16 pixels, 64 bytes per tile)
define(`__BIFROSTL_TILE_IMAGES', 48500)

# Location of the tile map (9x9=81 tiles)
define(`__BIFROSTL_TILE_MAP', 65281)

# Tile rendering order (1 for sequential, 7 for distributed)
define(`__BIFROSTL_TILE_ORDER', 7)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__BIFROSTL_ANIM_SPEED'
PUBLIC `__BIFROSTL_ANIM_GROUP'
PUBLIC `__BIFROSTL_STATIC_MIN'
PUBLIC `__BIFROSTL_STATIC_OVERLAP'
PUBLIC `__BIFROSTL_TILE_IMAGES'
PUBLIC `__BIFROSTL_TILE_MAP'
PUBLIC `__BIFROSTL_TILE_ORDER'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__BIFROSTL_ANIM_SPEED'     = __BIFROSTL_ANIM_SPEED
defc `__BIFROSTL_ANIM_GROUP'     = __BIFROSTL_ANIM_GROUP
defc `__BIFROSTL_STATIC_MIN'     = __BIFROSTL_STATIC_MIN
defc `__BIFROSTL_STATIC_OVERLAP' = __BIFROSTL_STATIC_OVERLAP
defc `__BIFROSTL_TILE_IMAGES'    = __BIFROSTL_TILE_IMAGES
defc `__BIFROSTL_TILE_MAP'       = __BIFROSTL_TILE_MAP
defc `__BIFROSTL_TILE_ORDER'     = __BIFROSTL_TILE_ORDER
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__BIFROSTL_ANIM_SPEED'      __BIFROSTL_ANIM_SPEED
`#define' `__BIFROSTL_ANIM_GROUP'      __BIFROSTL_ANIM_GROUP
`#define' `__BIFROSTL_STATIC_MIN'      __BIFROSTL_STATIC_MIN
`#define' `__BIFROSTL_STATIC_OVERLAP'  __BIFROSTL_STATIC_OVERLAP
`#define' `__BIFROSTL_TILE_IMAGES'     __BIFROSTL_TILE_IMAGES
`#define' `__BIFROSTL_TILE_MAP'        __BIFROSTL_TILE_MAP
`#define' `__BIFROSTL_TILE_ORDER'      __BIFROSTL_TILE_ORDER
')
