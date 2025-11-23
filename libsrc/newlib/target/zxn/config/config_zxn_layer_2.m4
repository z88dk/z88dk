divert(-1)

###############################################################
# LAYER 2 CONFIGURATION
# rebuild the library if changes are made
#

# Layer 2 is a new display mode with 256x192 pixel resolution
# with each pixel defined by an 8-bit colour.  Each pixel is
# therefore one byte with the display mapped in memory in left
# to right, top to bottom order.  The 8-bit colour is an index
# into one of two palettes defined for layer 2.  The palette
# contains 9-bit RGB333 colours.

# Layer 2 can be stored in any three consecutive 16k banks (that's
# 48k total).  The display is generated from the three banks
# pointed at by register 18, which can be changed at any time.
# Layer 2 can be brought into the z80's 64k memory space using
# the usual mmu or 128k banking scheme.  However, it can also
# be paged into the bottom 16k in a special write-only mode.
# The particular third of the display is specified and that 16k
# portion will be available write-only, meaning another program
# like the basic rom can be simultaneously executing from the
# same memory location.  A shadow layer 2 can be specified with
# register 19 that is intended to work with this paging mode.
# You can specify that the shadow layer 2 is paged into the bottom
# 16k instead of the active display determined by register 18 so that
# the program can work on a double buffered display separate from
# the one being displayed.  Note that register 18 always determines
# where the layer 2 active display is generated from - register 19
# has no real impact on anything except for this paging mode.
# Once drawing into the shadow display pointed at by register 19
# is complete, you must copy the bank location into register 18
# to see it.

# In addition to this, layer 2 can be hardware scrolled horizontally
# and vertically and it can be clipped against a viewport.

# Layer 2 is one of three video layers.  The first is the ula layer
# which generates the original spectrum / timex and new lo-res video
# modes, the second is this layer 2 and the third is the sprites
# layer.  These layers can be stacked in any order as set by
# register 21.  For layer 2, areas outside the clipping rectangle
# are transparent and will show other layers beneath.  Further,
# there is a global transparency colour that will cause that colour
# on layer 2 to be transparent, showing other layers underneath.
# If the final colour for a particular pixel is transparent,
# the pixel is displayed as black.

# NEXTREG 18: Layer 2 RAM Page
#
# define(`__REG_LAYER_2_RAM_PAGE', 18)
# define(`__RL2RP_MASK', 0x7f)

# NEXTREG 19: Layer 2 Shadow RAM Page
# see port 0x123b below
#
# define(`__REG_LAYER_2_SHADOW_RAM_PAGE', 19)
# define(`__RL2SRP_MASK', 0x7f)

# NEXTREG 20: Global Transparency Colour
#
# define(`__REG_GLOBAL_TRANSPARENCY_COLOR', 20)  # the transparent RGB332 colour

# NEXTREG 21: Layer Priority
#
# define(`__REG_SPRITE_LAYER_SYSTEM', 21)
# define(`__RSLS_ENABLE_LORES', 0x80)
# define(`__RSLS_LAYER_PRIORITY_SLU', 0x00)   # sprites on top, layer 2, ula on bottom
# define(`__RSLS_LAYER_PRIORITY_LSU', 0x04)
# define(`__RSLS_LAYER_PRIORITY_SUL', 0x08)
# define(`__RSLS_LAYER_PRIORITY_LUS', 0x0c)
# define(`__RSLS_LAYER_PRIORITY_USL', 0x10)
# define(`__RSLS_LAYER_PRIORITY_ULS', 0x14)
# define(`__RSLS_SPRITES_OVER_BORDER', 0x02)  # sprites display in border, overrides clipping window
# define(`__RSLS_SPRITES_VISIBLE', 0x01)      # sprite layer is enabled

# NEXTREG 22,23: Layer 2 Scroll
#
# define(`__REG_LAYER_2_OFFSET_X', 22)  # x offset in pixels, wraps
# define(`__REG_LAYER_2_OFFSET_Y', 23)  # y offset in pixels, wraps

# NEXTREG 24: Layer 2 clipping rectangle, coordinates are inclusive
#
# Send clipping rectangle as XL,XR,YT,YB in pixels (reset internal index: register 28)
#
# define(`__REG_CLIP_WINDOW_LAYER_2', 24)

# NEXTREG 28: Clipping Window Control
#
# define(`__REG_CLIP_WINDOW_CONTROL', 28)
# define(`__RCWC_RESET_ULA_CLIP_INDEX', 0x04)
# define(`__RCWC_RESET_SPRITE_CLIP_INDEX', 0x02)  # reset internal index for nextreg 25
# define(`__RCWC_RESET_LAYER_2_CLIP_INDEX', 0x01)

# PORT 0x123B: Layer 2 in Lower 16k

define(`__IO_LAYER_2_CONFIG', 0x123b)

define(`__IL2C_ENABLE_LOWER_16K', 0x01)      # Layer 2 enable vram visible in lower 16k in write only mode
define(`__IL2C_SHOW_LAYER_2', 0x02)          # Layer 2 enable display of layer 2 (reg 18 defines first 16k bank)
define(`__IL2C_SELECT_SHADOW_BUFFER', 0x08)  # Layer 2 choose shadow buffer for lower 16k (reg 19 defines first 16k page)
define(`__IL2C_BANK_SELECT_MASK', 0xc0)      # Layer 2 vram bank 0-2 visible in lower 16k
define(`__IL2C_BANK_SELECT_0', 0x00)
define(`__IL2C_BANK_SELECT_1', 0x40)
define(`__IL2C_BANK_SELECT_2', 0x80)

define(`__IO_123B_ENABLE_LOWER_16K', __IL2C_ENABLE_LOWER_16K)
define(`__IO_123B_SHOW_LAYER_2', __IL2C_SHOW_LAYER_2)
define(`__IO_123B_SELECT_SHADOW_BUFFER', __IL2C_SELECT_SHADOW_BUFFER)
define(`__IO_123B_BANK_SELECT_MASK', __IL2C_BANK_SELECT_MASK)
define(`__IO_123B_BANK_SELECT_0', __IL2C_BANK_SELECT_0)
define(`__IO_123B_BANK_SELECT_1', __IL2C_BANK_SELECT_1)
define(`__IO_123B_BANK_SELECT_2', __IL2C_BANK_SELECT_2)

# NOTE: AT THE PRESENT TIME, LAYER 2 CANNOT BE ACCESSED BY THE
# CPU AT SPEEDS GREATER THAN 7MHZ WHILE LAYER 2 IS DRAWN TO THE
# ACTIVE DISPLAY.  TO PREVENT THAT FROM HAPPENING THE NEXT IS
# CONFIGURED IN A "SAFE MODE" AT BOOT THAT AUTOMATICALLY SLOWS
# THE CPU TO 7MHZ WHILE THE DISPLAY IS BEING GENERATED IN THE
# 256X192 AREA OF THE SCREEN.

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_LAYER_2_CONFIG'

PUBLIC `__IL2C_ENABLE_LOWER_16K'
PUBLIC `__IL2C_SHOW_LAYER_2'
PUBLIC `__IL2C_SELECT_SHADOW_BUFFER'
PUBLIC `__IL2C_BANK_SELECT_MASK'
PUBLIC `__IL2C_BANK_SELECT_0'
PUBLIC `__IL2C_BANK_SELECT_1'
PUBLIC `__IL2C_BANK_SELECT_2'

PUBLIC `__IO_123B_ENABLE_LOWER_16K'
PUBLIC `__IO_123B_SHOW_LAYER_2'
PUBLIC `__IO_123B_SELECT_SHADOW_BUFFER'
PUBLIC `__IO_123B_BANK_SELECT_MASK'
PUBLIC `__IO_123B_BANK_SELECT_0'
PUBLIC `__IO_123B_BANK_SELECT_1'
PUBLIC `__IO_123B_BANK_SELECT_2'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_LAYER_2_CONFIG' = __IO_LAYER_2_CONFIG

defc `__IL2C_ENABLE_LOWER_16K' = __IL2C_ENABLE_LOWER_16K
defc `__IL2C_SHOW_LAYER_2' = __IL2C_SHOW_LAYER_2
defc `__IL2C_SELECT_SHADOW_BUFFER' = __IL2C_SELECT_SHADOW_BUFFER
defc `__IL2C_BANK_SELECT_MASK' = __IL2C_BANK_SELECT_MASK
defc `__IL2C_BANK_SELECT_0' = __IL2C_BANK_SELECT_0
defc `__IL2C_BANK_SELECT_1' = __IL2C_BANK_SELECT_1
defc `__IL2C_BANK_SELECT_2' = __IL2C_BANK_SELECT_2

defc `__IO_123B_ENABLE_LOWER_16K' = __IL2C_ENABLE_LOWER_16K
defc `__IO_123B_SHOW_LAYER_2' = __IL2C_SHOW_LAYER_2
defc `__IO_123B_SELECT_SHADOW_BUFFER' = __IL2C_SELECT_SHADOW_BUFFER
defc `__IO_123B_BANK_SELECT_MASK' = __IL2C_BANK_SELECT_MASK
defc `__IO_123B_BANK_SELECT_0' = __IL2C_BANK_SELECT_0
defc `__IO_123B_BANK_SELECT_1' = __IL2C_BANK_SELECT_1
defc `__IO_123B_BANK_SELECT_2' = __IL2C_BANK_SELECT_2
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_LAYER_2_CONFIG'  __IO_LAYER_2_CONFIG

`#define' `__IL2C_ENABLE_LOWER_16K'  __IL2C_ENABLE_LOWER_16K
`#define' `__IL2C_SHOW_LAYER_2'  __IL2C_SHOW_LAYER_2
`#define' `__IL2C_SELECT_SHADOW_BUFFER'  __IL2C_SELECT_SHADOW_BUFFER
`#define' `__IL2C_BANK_SELECT_MASK'  __IL2C_BANK_SELECT_MASK
`#define' `__IL2C_BANK_SELECT_0'  __IL2C_BANK_SELECT_0
`#define' `__IL2C_BANK_SELECT_1'  __IL2C_BANK_SELECT_1
`#define' `__IL2C_BANK_SELECT_2'  __IL2C_BANK_SELECT_2

`#define' `__IO_123B_ENABLE_LOWER_16K'  __IL2C_ENABLE_LOWER_16K
`#define' `__IO_123B_SHOW_LAYER_2'  __IL2C_SHOW_LAYER_2
`#define' `__IO_123B_SELECT_SHADOW_BUFFER'  __IL2C_SELECT_SHADOW_BUFFER
`#define' `__IO_123B_BANK_SELECT_MASK'  __IL2C_BANK_SELECT_MASK
`#define' `__IO_123B_BANK_SELECT_0'  __IL2C_BANK_SELECT_0
`#define' `__IO_123B_BANK_SELECT_1'  __IL2C_BANK_SELECT_1
`#define' `__IO_123B_BANK_SELECT_2'  __IL2C_BANK_SELECT_2
')
