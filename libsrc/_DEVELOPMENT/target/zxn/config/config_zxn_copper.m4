divert(-1)

###############################################################
# COPPER USER CONFIGURATION
# rebuild the library if changes are made
#

# The ZXN Copper is an independent device operating in parallel
# with the cpu whose timing is tied to the video display generation.
# Nominally it operates at 7Mhz with each copper instruction
# taking the same amount of time as the movement of the raster by
# one horizontal pixel.
#
# Vertically the display consists of 262 lines in 60Hz mode and
# 311 lines in 50Hz mode.  Lines 0-191 always correspond to the
# area containing the active display.  In 60Hz mode, the next 32
# lines are bottom border, 8 lines for Vsync, and 32 lines for top
# border.  In 50Hz mode, the next 56 lines are bottom border, 8
# lines for Vsync and 56 lines for top border.
#
# 50Hz                          60Hz
# Lines                         Lines
#
#   0-191  Display                0-191  Display
# 192-247  Bottom Border        192-223  Bottom Border
# 248-255  Vsync (interrupt)    224-231  Vsync (interrupt)
# 256-311  Top Border           232-261  Top Border
#
# Horizontally the display is the same in 50 or 60Hz mode but it
# varies by model.  It consists of 448 pixels (0-447) in 48k mode
# and 456 pixels (0-455) in 128k mode.  Grouped in eight pixels
# that's screen bytes 0-55 in 48k mode and 0-56 in 128k mode.
#
# 48k mode                      128k mode
# Bytes  Pixels                 Bytes  Pixels
#
#  0-31    0-255  Display        0-31    0-255  Display
# 32-39  256-319  Right Border  32-39  256-319  Right Border
# 40-51  320-415  HBlank        40-51  320-415  HBlank
# 52-55  416-447  Left Border   52-56  416-455  Left Border
#
# The ZXN Copper understands two operations:
#
# (1) Wait for a particular line (0-311 @ 50Hz or 0-261 @ 60Hz)
#     and a horizontal character position (0-55 or 0-56)
#
# (2) Write a value to a nextreg.
#
# These operations are encoded into a 16-bit instruction which
# is stored in big endian form.  The Copper has a 2k code space
# on the fpga, which means an instruction space of 1024 instructions.
#
# Programming the Copper involves writing zeroes to nextreg 97 & 98
# to turn off the Copper and set the current instruction index to zero.
# Then the program is loaded into the Copper by writing bytes to
# nextreg 96.  Once that's done, the Copper can be switched on in
# one of three modes as indicated for nextreg 98 below.

# NEXTREG 96: Copper Data
#
# define(`__REG_COPPER_DATA', 96)

# NEXTREG 97: Copper Control Lo
#
# define(`__REG_COPPER_CONTROL_LO', 97)

# NEXTREG 98: Copper Control Hi
#
# define(`__REG_COPPER_CONTROL_HI', 98)
# define(`__RCCH_COPPER_STOP', 0x00)
# define(`__RCCH_COPPER_RUN_ONCE', 0x40)
# define(`__RCCH_COPPER_RUN_LOOP', 0x80)
# define(`__RCCH_COPPER_RUN_ON_INTERRUPT', 0xc0)

# For modes RUN_ONCE and RUN_ON_INTERRUPT, the Copper program
# should be terminated by a stop instruction (wait for a
# non-existent line).  For RUN_LOOP, the Copper continuously
# executes all instructions in its 2k memory, looping from
# the end back to the beginning.  If the instruction list is
# less than 2k, it should be padded with nops (a write of 0
# to nextreg 0) which will each take one pixel in time to
# execute.  More advanced applications can have the dma stream
# new instructions into the copper as it executes so that the
# instruction space is effectively larger than 2k.

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
')
