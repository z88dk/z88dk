divert(-1)

###############################################################
# LINE INTERRUPT USER CONFIGURATION
# rebuild the library if changes are made
#

# The hardware generates the display in vertical lines,
# numbered as follows:
#
# 50Hz                          60Hz
# Lines                         Lines
#
#   0-191  Display                0-191  Display
# 192-247  Bottom Border        192-223  Bottom Border
# 248-255  Vsync (interrupt)    224-231  Vsync (interrupt)
# 256-311  Top Border           232-261  Top Border
#
# More details can be found in config_zxn_copper.m4.
#
# The standard spectrum generates one interrupt per frame
# at the beginning of vsync.  This leaves about 14k cycles
# before the top area of the active display is drawn in
# lines 0-191 (~224 cycles @ 3.5MHz per line).
#
# The ZXN adds the ability to generate an interrupt at the 
# beginning of any vertical line just as the active display
# area is being generated (in terms of copper timing this is
# in horizontal byte 0).  The programming is handled through
# nextreg registers 34 and 35:
#

# NEXTREG 34: Line Interrupt Control

# define(`__REG_LINE_INTERRUPT_CONTROL', 34)
# define(`__RLIC_INTERRUPT_FLAG', 0x80)           # On read, set if /int is being asserted internally
# define(`__RLIC_DISABLE_ULA_INTERRUPT', 0x04)    # Set to disable the vbi interrupt, mirror of port 0xff bit 6
# define(`__RLIC_ENABLE_LINE_INTERRUPT', 0x02)    # Set to enable the line interrupt
# define(`__RLIC_LINE_INTERRUPT_VALUE_MSB', 0x01) # Bit 8 of the line number to interrupt on

# NEXTREG 35: Line Interrupt Value LSB

# define(`__REG_LINE_INTERRUPT_VALUE_LSB', 35)    # Bits 0..7 of the line number to interrupt on

#
# If the line interrupt is enabled, the standard vbi interrupt will
# continue to function so that there will be two interrupts per frame:
# one at vsync and one at the beginning of the indicated line.
# The /INT line is asserted in exactly the same way for both interrupts.
#
# The vbi interrupt can be shut off by setting the appropriate bit
# in nextreg 34 or port 0xff.  One application might be to shut off the vbi
# interrupt and enable a line interrupt on line 192.  This would move the
# interrupt to just after the last line in the display is drawn, informing the
# program when it has maximum time to make changes to the display before
# the active display (line 0) is drawn again.
#
# Rather than enabling a line interrupt, the program can also poll
# the current line position by reading nextreg 30 and 31.
#

# NEXTREG 30: Active Line MSB

# define(`__REG_ACTIVE_VIDEO_LINE_MSB', 30)       # Bit 8 of the current line number

# NEXTREG 31: Active Line LSB

# define(`__REG_ACTIVE_VIDEO_LINE_LSB', 31)       # Bits 7..0 of the current line number

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
