divert(-1)

###############################################################
# BIFROST*2 MULTICOLOUR ENGINE CONFIGURATION
# rebuild the library if changes are made
#

# Animation size: 2 or 4 frames per animation group
define(`__BIFROST2_ANIM_GROUP', 4)

# First non-animated frame
define(`__BIFROST2_STATIC_MIN', 128)

# Value subtracted from non-animated frames
define(`__BIFROST2_STATIC_OVERLAP', 128)

# Default location of multicolor tiles table (16x16 pixels, 64 bytes per tile)
define(`__BIFROST2_TILE_IMAGES', 49000)

# Tile rendering order (1 for sequential, 7 or 9 for distributed)
define(`__BIFROST2_TILE_ORDER', 7)

# Location of the tile map (11x10=110 tiles)
define(`__BIFROST2_TILE_MAP', 65281)

# Number of char rows rendered in multicolor (3-22)
define(`__BIFROST2_TOTAL_ROWS', 22)

define(`__BIFROST2_HOLE', eval(__BIFROST2_TOTAL_ROWS*376+56567))
define(`__BIFROST2_HOLE_SIZE', eval(64829-__BIFROST2_HOLE))
ifelse(eval(__BIFROST2_HOLE_SIZE < 0), 1, `define(`__BIFROST2_HOLE_SIZE', 0)')

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__BIFROST2_ANIM_GROUP'
PUBLIC `__BIFROST2_STATIC_MIN'
PUBLIC `__BIFROST2_STATIC_OVERLAP'
PUBLIC `__BIFROST2_TILE_IMAGES'
PUBLIC `__BIFROST2_TILE_ORDER'
PUBLIC `__BIFROST2_TILE_MAP'
PUBLIC `__BIFROST2_TOTAL_ROWS'
PUBLIC `__BIFROST2_HOLE'
PUBLIC `_BIFROST2_HOLE'
PUBLIC `__BIFROST2_HOLE_SIZE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__BIFROST2_ANIM_GROUP'     = __BIFROST2_ANIM_GROUP
defc `__BIFROST2_STATIC_MIN'     = __BIFROST2_STATIC_MIN
defc `__BIFROST2_STATIC_OVERLAP' = __BIFROST2_STATIC_OVERLAP
defc `__BIFROST2_TILE_IMAGES'    = __BIFROST2_TILE_IMAGES
defc `__BIFROST2_TILE_ORDER'     = __BIFROST2_TILE_ORDER
defc `__BIFROST2_TILE_MAP'       = __BIFROST2_TILE_MAP
defc `__BIFROST2_TOTAL_ROWS'     = __BIFROST2_TOTAL_ROWS
defc `__BIFROST2_HOLE'           = __BIFROST2_HOLE
defc `_BIFROST2_HOLE'            = __BIFROST2_HOLE
defc `__BIFROST2_HOLE_SIZE'      = __BIFROST2_HOLE_SIZE

; `define(`__BIFROST2_TOTAL_ROWS',' __BIFROST2_TOTAL_ROWS)
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__BIFROST2_ANIM_GROUP'      __BIFROST2_ANIM_GROUP
`#define' `__BIFROST2_STATIC_MIN'      __BIFROST2_STATIC_MIN
`#define' `__BIFROST2_STATIC_OVERLAP'  __BIFROST2_STATIC_OVERLAP
`#define' `__BIFROST2_TILE_IMAGES'     __BIFROST2_TILE_IMAGES
`#define' `__BIFROST2_TILE_ORDER'      __BIFROST2_TILE_ORDER
`#define' `__BIFROST2_TILE_MAP'        __BIFROST2_TILE_MAP
`#define' `__BIFROST2_TOTAL_ROWS'      __BIFROST2_TOTAL_ROWS
`#define' `__BIFROST2_HOLE'            __BIFROST2_HOLE
`#define' `__BIFROST2_HOLE_SIZE'       __BIFROST2_HOLE_SIZE
')
