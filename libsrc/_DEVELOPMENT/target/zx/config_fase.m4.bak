divert(-1)

###############################################################
# FASE 50HZ SPRITE ENGINE CONFIGURATION
# rebuild the library if changes are made
#

# Tile mode: 0 = no index, 1 = indexed bitmap, 2 = indexed attr, 3 = fully indexed
define(`__FASE_TILE_MODE', 3)

# Smooth: 0 = two pixel sprite movement, 1 = one pixel sprite movement
define(`__FASE_SMOOTH', 1)

# Clip top: 0 = disable, 1 = clip bar, 2 = software clip
define(`__FASE_CLIP_TOP', 1)

# Clip bottom: 0 = disable, 1 = clip bar, 2 = software clip
define(`__FASE_CLIP_BOTTOM', 1)

# Clip horizontal: 0 = disable, 1 = clip bar
define(`__FASE_CLIP_HORIZONTAL', 1)

# Safe vertical coordinates: non-zero if y coordinate is always valid
define(`__FASE_SAFE_VCOORD', 1)

# Safe horizontal coordinates: non-zero if x coordinate is always valid
define(`__FASE_SAFE_HCOORD', 1)

# Left margin in characters
define(`__FASE_MARGIN_LEFT', 1)

# Top margin in characters
define(`__FASE_MARGIN_TOP', 1)

# Indicate if 256-byte screen address lookup should be used (faster,larger)
define(`__FASE_USE_TABLE', 1)

# Max number of bullets in game 0-8
define(`__FASE_NUM_BULLETS', 0)

# Max number of sprites in game 1-12
define(`__FASE_NUM_SPRITES', 6)

# Colour of sync bar: ink 0-7 + 8 for bright
define(`__FASE_SYNC_BAR_COLOR', 0)

# Colour of clip bar: ink 0-7 + 8 for bright
define(`__FASE_CLIP_BAR_COLOR', 0)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__FASE_TILE_MODE'
PUBLIC `__FASE_SMOOTH'
PUBLIC `__FASE_CLIP_TOP'
PUBLIC `__FASE_CLIP_BOTTOM'
PUBLIC `__FASE_CLIP_HORIZONTAL'
PUBLIC `__FASE_SAFE_VCOORD'
PUBLIC `__FASE_SAFE_HCOORD'
PUBLIC `__FASE_MARGIN_LEFT'
PUBLIC `__FASE_MARGIN_TOP'
PUBLIC `__FASE_USE_TABLE'
PUBLIC `__FASE_NUM_BULLETS'
PUBLIC `__FASE_NUM_SPRITES'
PUBLIC `__FASE_SYNC_BAR_COLOR'
PUBLIC `__FASE_CLIP_BAR_COLOR'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__FASE_TILE_MODE'       = __FASE_TILE_MODE
defc `__FASE_SMOOTH'          = __FASE_SMOOTH
defc `__FASE_CLIP_TOP'        = __FASE_CLIP_TOP
defc `__FASE_CLIP_BOTTOM'     = __FASE_CLIP_BOTTOM
defc `__FASE_CLIP_HORIZONTAL' = __FASE_CLIP_HORIZONTAL
defc `__FASE_SAFE_VCOORD'     = __FASE_SAFE_VCOORD
defc `__FASE_SAFE_HCOORD'     = __FASE_SAFE_HCOORD
defc `__FASE_MARGIN_LEFT'     = __FASE_MARGIN_LEFT
defc `__FASE_MARGIN_TOP'      = __FASE_MARGIN_TOP
defc `__FASE_USE_TABLE'       = __FASE_USE_TABLE
defc `__FASE_NUM_BULLETS'     = __FASE_NUM_BULLETS
defc `__FASE_NUM_SPRITES'     = __FASE_NUM_SPRITES
defc `__FASE_SYNC_BAR_COLOR'  = __FASE_SYNC_BAR_COLOR
defc `__FASE_CLIP_BAR_COLOR'  = __FASE_CLIP_BAR_COLOR
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__FASE_TILE_MODE'        __FASE_TILE_MODE
`#define' `__FASE_SMOOTH'           __FASE_SMOOTH
`#define' `__FASE_CLIP_TOP'         __FASE_CLIP_TOP
`#define' `__FASE_CLIP_BOTTOM'      __FASE_CLIP_BOTTOM
`#define' `__FASE_CLIP_HORIZONTAL'  __FASE_CLIP_HORIZONTAL
`#define' `__FASE_SAFE_VCOORD'      __FASE_SAFE_VCOORD
`#define' `__FASE_SAFE_HCOORD'      __FASE_SAFE_HCOORD
`#define' `__FASE_MARGIN_LEFT'      __FASE_MARGIN_LEFT
`#define' `__FASE_MARGIN_TOP'       __FASE_MARGIN_TOP
`#define' `__FASE_USE_TABLE'        __FASE_USE_TABLE
`#define' `__FASE_NUM_BULLETS'      __FASE_NUM_BULLETS
`#define' `__FASE_NUM_SPRITES'      __FASE_NUM_SPRITES
`#define' `__FASE_SYNC_BAR_COLOR'   __FASE_SYNC_BAR_COLOR
`#define' `__FASE_CLIP_BAR_COLOR'   __FASE_CLIP_BAR_COLOR
')
