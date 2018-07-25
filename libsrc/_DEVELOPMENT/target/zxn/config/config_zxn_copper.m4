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
# 312 lines in 50Hz mode.  Lines 0-191 always correspond to the
# area containing the active display.
#
# 50Hz                          60Hz
# Lines                         Lines
#
#   0-191  Display                0-191  Display
# 192-247  Bottom Border        192-223  Bottom Border
# 248-255  Vsync (interrupt)    224-231  Vsync (interrupt)
# 256-311  Top Border           232-261  Top Border
#
# Horizontally the display is the same in 50Hz or 60Hz mode but it
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
#     and a horizontal character position (0-55 or 0-56).  The
#     wait is an equality comparison for line and a greater equal
#     comparison for horizontal character position.
#
# (2) Write a value to a nextreg.
#
# These operations are encoded into a 16-bit instruction which
# is stored in big endian form.  The Copper has a 2k code space
# on the fpga, which means an instruction space of 1024 instructions.
#
# z88dk/z80asm adds the following instructions to assemble copper code:
#
# cu.wait line,hor   ; wait for LINE line and HORIZONTAL hor
# cu.move reg,val    ; move val to nextreg reg
# cu.nop             ; wait one horizontal pixel (cu.move 0,0)
# cu.stop            ; stop the copper (impossible wait) 
#
# The instruction format can be found at:
# https://docs.google.com/document/d/1nhBNre5ePgelGfcB0KRmut1D3lUlk8R1IFj4MAmAiK0/edit
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
# define(`__REG_COPPER_CONTROL_L', 97)

# NEXTREG 98: Copper Control Hi
#
# define(`__REG_COPPER_CONTROL_H', 98)
# define(`__RCCH_COPPER_STOP', 0x00)
# define(`__RCCH_COPPER_RUN_LOOP_RESET', 0x40)
# define(`__RCCH_COPPER_RUN_LOOP', 0x80)
# define(`__RCCH_COPPER_RUN_VBI', 0xc0)

# STOP causes the copper to stop executing instructions
# and hold the instruction pointer at its current position.
#
# RUN_LOOP_RESET causes the copper to reset its instruction
# pointer to 0 and run in LOOP mode (see next).
#
# RUN_LOOP causes the copper to restart with the instruction
# pointer at its current position.  Once the end of the instruction
# list is reached, the copper loops back to the beginning.
#
# RUN_VBI causes the copper to reset its instruction
# pointer to 0 and run in VBI mode.  The name "VBI" is a misnomer;
# in VBI mode the copper runs its program and automatically restarts
# it by resetting its instruction pointer to 0 at position 0,0 with
# no connection to the vbi interrupt.

# Note that modes RUN_LOOP_RESET and RUN_VBI will only reset
# the instruction pointer to zero if the mode actually changes
# to RUN_LOOP_RESET or RUN_VBI.  Writing the same mode in a
# second write will not cause the instruction pointer to zero.

# It is possible to write values into the copper's instruction
# space while it is running and since the copper constantly
# refetches a wait instruction it is executing, you can cause
# the wait instruction to end prematurely by changing it to
# something else.

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
