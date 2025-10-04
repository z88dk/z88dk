divert(-1)

###############################################################
# ULA USER CONFIGURATION
# rebuild the library if changes are made
#

# The ULA is the ic in the spectrum responsible for video
# generation.  The Next implements timex's version of the ula
# which adds several video modes and adds a new lo-res mode
# exclusive to the next.
#
# Default ula mode (Timex DFILE_1):
#
# 256x192 pixel, 32x24 attributes
# display file @ 0x4000, 6912 bytes
#
# Timex DFILE_2:
#
# 256x192 pixel, 32x24 attributes
# display file @ 0x6000, 6912 bytes
#
# Timex hi-colour mode:
#
# 256x192 pixel, 32x192 attributes
# display file 1 @ 0x4000, 6144 bytes (pixel only)
# display file 2 @ 0x6000, 6144 bytes (attributes only)
#
# Timex hi-res mode:
#
# 512x192 monochrome (colour determined by port 0xff)
# display file 1 @ 0x4000, 6144 bytes (pixel even columns)
# display file 2 @ 0x6000, 6144 bytes (pixel odd columns)
#
# Lo-Res mode:
#
# 128x96 each pixel one byte, 256 colours
# display file 1 @ 0x4000, 6144 bytes (top half of screen)
# display file 2 @ 0x6000, 6144 bytes (bottom half of screen)
#
# The display is always generated from data stored in 16k bank 5
# (8k banks 10/11) which can be paged into the z80's address
# space at many locations using the Next's memory mapping scheme.
# However, on the traditional spectrum, 16k bank 5 is fixed at
# location 0x4000 in memory and that is why the memory addresses
# are listed as such above.
#
# The 128k spectrum also allowed the display to be generated
# from a second location - at address 0xc000 using 16k bank 7.
# This effectively added double buffering capability.  The Next
# also allows all video modes except Lo-Res to have a second
# or alternate source in bank 7.  Again the nominal address 0xc000
# has to do with the original spectrum only being capable of
# mapping bank 7 to address 0xc000 in memory but the Next is
# capable of mapping this bank at multiple places in the z80's
# address space.  However it is important to note that when
# bank 7 is used for the ula, layer 2 cannot be mixed into the
# display.  If a second buffer ula screen is needed along with
# layer 2, it is recommended the second timex display file
# is used for double buffering instead of the 128k's in bank 7.
#
# The Next also adds a viewport for all ula modes and hardware
# scrolling for the Lo-Res mode only.
#
# Colour is done via palette lookup to generate RGB333 colours
# for display.  The palette is initialized so that the reset
# values correspond to colour generation as on the original
# model.
#
# The Next generates three display layers:  the ula, layer 2
# and sprites.  These layers can be sequenced in any order
# and the viewports applied as well as the global transparency
# colour determine whether any layer exposes other layers
# underneath it.

# PORT 0xFE: Border and Sound

define(`__IO_FE', 0xfe)
define(`__IO_FE_EAR', 0x10)     # 1-bit sound output, write to tape
define(`__IO_FE_MIC', 0x08)     # read from tape
define(`__IO_FE_BORDER_MASK', 0x07)   # border colour in bottom three bits
                                #   (passes through RGB333 palette lookup)

# PORT 0xFF: Timex Video Modes

define(`__IO_TIMEX_VIDEO_MODE', 0xff)

define(`__IO_TVM_DISABLE_ULA_INTERRUPT', 0x40)
define(`__IO_TVM_DFILE_1', 0x0)         # spectrum display
define(`__IO_TVM_DFILE_2', 0x01)        # spectrum display @ 0x6000
define(`__IO_TVM_HICOLOR', 0x02)        # timex hi-colour
define(`__IO_TVM_HIRES', 0x06)          # timex hi-res
define(`__IO_TVM_HIRES_BLACK', 0x06)    # timex hi-res black ink
define(`__IO_TVM_HIRES_BLUE', 0x0e)     # timex hi-res blue ink
define(`__IO_TVM_HIRES_RED', 0x16)      # timex hi-res red ink
define(`__IO_TVM_HIRES_MAGENTA', 0x1e)  # timex hi-res magenta ink
define(`__IO_TVM_HIRES_GREEN', 0x26)    # timex hi-res green ink
define(`__IO_TVM_HIRES_CYAN', 0x2e)     # timex hi-res cyan ink
define(`__IO_TVM_HIRES_YELLOW', 0x36)   # timex hi-res yellow ink
define(`__IO_TVM_HIRES_WHITE', 0x3e)    # timex hi-res white ink

define(`__IO_FF_DISABLE_ULA_INTERRUPT', __IO_TVM_DISABLE_ULA_INTERRUPT)
define(`__IO_FF_DFILE_1', __IO_TVM_DFILE_1)
define(`__IO_FF_DFILE_2', __IO_TVM_DFILE_2)
define(`__IO_FF_HICOLOR', __IO_TVM_HICOLOR)
define(`__IO_FF_HIRES', __IO_TVM_HIRES)
define(`__IO_FF_HIRES_BLACK', __IO_TVM_HIRES_BLACK)
define(`__IO_FF_HIRES_BLUE', __IO_TVM_HIRES_BLUE)
define(`__IO_FF_HIRES_RED', __IO_TVM_HIRES_RED)
define(`__IO_FF_HIRES_MAGENTA', __IO_TVM_HIRES_MAGENTA)
define(`__IO_FF_HIRES_GREEN', __IO_TVM_HIRES_GREEN)
define(`__IO_FF_HIRES_CYAN', __IO_TVM_HIRES_CYAN)
define(`__IO_FF_HIRES_YELLOW', __IO_TVM_HIRES_YELLOW)
define(`__IO_FF_HIRES_WHITE', __IO_TVM_HIRES_WHITE)

# PORT 0x7FFD: 128k Memory Mapping 1
#
# define(`__IO_7FFD', 0x7ffd)
# define(`__IO_7FFD_LOCK', 0x20)
# define(`__IO_7FFD_ROM0', 0x10)
# define(`__IO_7FFD_ALT_DFILE', 0x08)   # ula display comes from bank 7 (not lo-res)
# define(`__IO_7FFD_RAM_PAGE_MASK', 0x07)

# NEXTREG 8: Peripheral 3
#
# define(`__REG_PERIPHERAL_3', 8)
# define(`__RP3_STEREO_ABC', 0x00)
# define(`__RP3_STEREO_ACB', 0x20)
# define(`__RP3_ENABLE_SPEAKER', 0x10)
# define(`__RP3_ENABLE_SPECDRUM', 0x08)
# define(`__RP3_ENABLE_COVOX', 0x08)
# define(`__RP3_ENABLE_TIMEX', 0x04)       # enable timex video modes via port 0xff
# define(`__RP3_ENABLE_TURBOSOUND', 0x02)
# define(`__RP3_UNLOCK_7FFD', 0x80)

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
# define(`__RSLS_SPRITES_OVER_BORDER', 0x02)
# define(`__RSLS_SPRITES_VISIBLE', 0x01)

# NEXTREG 26: ULA clipping rectangle, coordinates are inclusive
#
# Send clipping rectangle as XL,XR,YT,YB in pixels (reset internal index: register 28)
#
# define(`__REG_CLIP_WINDOW_ULA', 26)

# NEXTREG 28: Clipping Window Control
#
# define(`__REG_CLIP_WINDOW_CONTROL', 28)
# define(`__RCWC_RESET_ULA_CLIP_INDEX', 0x04)     # reset internal index for nextreg 26
# define(`__RCWC_RESET_SPRITE_CLIP_INDEX', 0x02)
# define(`__RCWC_RESET_LAYER_2_CLIP_INDEX', 0x01)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_FE'
PUBLIC `__IO_FE_EAR'
PUBLIC `__IO_FE_MIC'
PUBLIC `__IO_FE_BORDER_MASK'

PUBLIC `__IO_TIMEX_VIDEO_MODE'

PUBLIC `__IO_TVM_DISABLE_ULA_INTERRUPT'
PUBLIC `__IO_TVM_DFILE_1'
PUBLIC `__IO_TVM_DFILE_2'
PUBLIC `__IO_TVM_HICOLOR'
PUBLIC `__IO_TVM_HIRES'
PUBLIC `__IO_TVM_HIRES_BLACK'
PUBLIC `__IO_TVM_HIRES_BLUE'
PUBLIC `__IO_TVM_HIRES_RED'
PUBLIC `__IO_TVM_HIRES_MAGENTA'
PUBLIC `__IO_TVM_HIRES_GREEN'
PUBLIC `__IO_TVM_HIRES_CYAN'
PUBLIC `__IO_TVM_HIRES_YELLOW'
PUBLIC `__IO_TVM_HIRES_WHITE'

PUBLIC `__IO_FF_DISABLE_ULA_INTERRUPT'
PUBLIC `__IO_FF_DFILE_1'
PUBLIC `__IO_FF_DFILE_2'
PUBLIC `__IO_FF_HICOLOR'
PUBLIC `__IO_FF_HIRES'
PUBLIC `__IO_FF_HIRES_BLACK'
PUBLIC `__IO_FF_HIRES_BLUE'
PUBLIC `__IO_FF_HIRES_RED'
PUBLIC `__IO_FF_HIRES_MAGENTA'
PUBLIC `__IO_FF_HIRES_GREEN'
PUBLIC `__IO_FF_HIRES_CYAN'
PUBLIC `__IO_FF_HIRES_YELLOW'
PUBLIC `__IO_FF_HIRES_WHITE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_FE' = __IO_FE
defc `__IO_FE_EAR' = __IO_FE_EAR
defc `__IO_FE_MIC' = __IO_FE_MIC
defc `__IO_FE_BORDER_MASK' = __IO_FE_BORDER_MASK

defc `__IO_TIMEX_VIDEO_MODE' = __IO_TIMEX_VIDEO_MODE

defc `__IO_TVM_DISABLE_ULA_INTERRUPT' = __IO_TVM_DISABLE_ULA_INTERRUPT
defc `__IO_TVM_DFILE_1' = __IO_TVM_DFILE_1
defc `__IO_TVM_DFILE_2' = __IO_TVM_DFILE_2
defc `__IO_TVM_HICOLOR' = __IO_TVM_HICOLOR
defc `__IO_TVM_HIRES' = __IO_TVM_HIRES
defc `__IO_TVM_HIRES_BLACK' = __IO_TVM_HIRES_BLACK
defc `__IO_TVM_HIRES_BLUE' = __IO_TVM_HIRES_BLUE
defc `__IO_TVM_HIRES_RED' = __IO_TVM_HIRES_RED
defc `__IO_TVM_HIRES_MAGENTA' = __IO_TVM_HIRES_MAGENTA
defc `__IO_TVM_HIRES_GREEN' = __IO_TVM_HIRES_GREEN
defc `__IO_TVM_HIRES_CYAN' = __IO_TVM_HIRES_CYAN
defc `__IO_TVM_HIRES_YELLOW' = __IO_TVM_HIRES_YELLOW
defc `__IO_TVM_HIRES_WHITE' = __IO_TVM_HIRES_WHITE

defc `__IO_FF_DISABLE_ULA_INTERRUPT' = __IO_TVM_DISABLE_ULA_INTERRUPT
defc `__IO_FF_DFILE_1' = __IO_TVM_DFILE_1
defc `__IO_FF_DFILE_2' = __IO_TVM_DFILE_2
defc `__IO_FF_HICOLOR' = __IO_TVM_HICOLOR
defc `__IO_FF_HIRES' = __IO_TVM_HIRES
defc `__IO_FF_HIRES_BLACK' = __IO_TVM_HIRES_BLACK
defc `__IO_FF_HIRES_BLUE' = __IO_TVM_HIRES_BLUE
defc `__IO_FF_HIRES_RED' = __IO_TVM_HIRES_RED
defc `__IO_FF_HIRES_MAGENTA' = __IO_TVM_HIRES_MAGENTA
defc `__IO_FF_HIRES_GREEN' = __IO_TVM_HIRES_GREEN
defc `__IO_FF_HIRES_CYAN' = __IO_TVM_HIRES_CYAN
defc `__IO_FF_HIRES_YELLOW' = __IO_TVM_HIRES_YELLOW
defc `__IO_FF_HIRES_WHITE' = __IO_TVM_HIRES_WHITE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_FE'  __IO_FE
`#define' `__IO_FE_EAR'  __IO_FE_EAR
`#define' `__IO_FE_MIC'  __IO_FE_MIC
`#define' `__IO_FE_BORDER_MASK'  __IO_FE_BORDER_MASK

`#define' `__IO_TIMEX_VIDEO_MODE'  __IO_TIMEX_VIDEO_MODE

`#define' `__IO_TVM_DISABLE_ULA_INTERRUPT'  __IO_TVM_DISABLE_ULA_INTERRUPT
`#define' `__IO_TVM_DFILE_1'  __IO_TVM_DFILE_1
`#define' `__IO_TVM_DFILE_2'  __IO_TVM_DFILE_2
`#define' `__IO_TVM_HICOLOR'  __IO_TVM_HICOLOR
`#define' `__IO_TVM_HIRES'  __IO_TVM_HIRES
`#define' `__IO_TVM_HIRES_BLACK'  __IO_TVM_HIRES_BLACK
`#define' `__IO_TVM_HIRES_BLUE'  __IO_TVM_HIRES_BLUE
`#define' `__IO_TVM_HIRES_RED'  __IO_TVM_HIRES_RED
`#define' `__IO_TVM_HIRES_MAGENTA'  __IO_TVM_HIRES_MAGENTA
`#define' `__IO_TVM_HIRES_GREEN'  __IO_TVM_HIRES_GREEN
`#define' `__IO_TVM_HIRES_CYAN'  __IO_TVM_HIRES_CYAN
`#define' `__IO_TVM_HIRES_YELLOW'  __IO_TVM_HIRES_YELLOW
`#define' `__IO_TVM_HIRES_WHITE'  __IO_TVM_HIRES_WHITE

`#define' `__IO_FF_DISABLE_ULA_INTERRUPT'  __IO_TVM_DISABLE_ULA_INTERRUPT
`#define' `__IO_FF_DFILE_1'  __IO_TVM_DFILE_1
`#define' `__IO_FF_DFILE_2'  __IO_TVM_DFILE_2
`#define' `__IO_FF_HICOLOR'  __IO_TVM_HICOLOR
`#define' `__IO_FF_HIRES'  __IO_TVM_HIRES
`#define' `__IO_FF_HIRES_BLACK'  __IO_TVM_HIRES_BLACK
`#define' `__IO_FF_HIRES_BLUE'  __IO_TVM_HIRES_BLUE
`#define' `__IO_FF_HIRES_RED'  __IO_TVM_HIRES_RED
`#define' `__IO_FF_HIRES_MAGENTA'  __IO_TVM_HIRES_MAGENTA
`#define' `__IO_FF_HIRES_GREEN'  __IO_TVM_HIRES_GREEN
`#define' `__IO_FF_HIRES_CYAN'  __IO_TVM_HIRES_CYAN
`#define' `__IO_FF_HIRES_YELLOW'  __IO_TVM_HIRES_YELLOW
`#define' `__IO_FF_HIRES_WHITE'  __IO_TVM_HIRES_WHITE
')
