divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__VGL', 1)


; For MODEL 4000 / 4004
define(`__VGL_KEY_STATUS_ADDRESS', 0xdb00)
define(`__VGL_KEY_CURRENT_ADDRESS', 0xdb01)

define(`__VGL_DISPLAY_COLS', 20)
define(`__VGL_DISPLAY_ROWS', 4)
define(`__VGL_DISPLAY_CONTROL_PORT', 0x0a)
define(`__VGL_DISPLAY_REFRESH_ADDRESS', 0xdcf0)	#0xdcf0...0xdcf3 for each of the 4 rows
define(`__VGL_DISPLAY_CURSOR_X_ADDRESS', 0xdcf4)
define(`__VGL_DISPLAY_CURSOR_Y_ADDRESS', 0xdcf5)
define(`__VGL_DISPLAY_CURSOR_MODE_ADDRESS', 0xdcf6)
define(`__VGL_DISPLAY_CLEAR_ADDRESS', 0xdcf7)	# Can be set to 0 or 1
define(`__VGL_DISPLAY_VRAM_START', 0xdca0)


#	// Key codes
#	#define KEY_NONE	0
#	#define KEY_ASTERISK	0x2a	// Asterisk (top left key) without modifiers
#	#define KEY_BREAK	0x60	// Asterisk (top left key) + Shift
#	
#	#define KEY_HELP	0x83	// HELP/TAB without modifiers
#	#define KEY_TAB		0x82	// HELP/TAB + Shift
#	
#	#define KEY_PLAYER_LEFT	0x7b	// LEFT PLAYER without modifiers
#	#define KEY_PLAYER_RIGHT	0x7f	// RIGHT PLAYER without modifiers
#	//#define KEY_PLAYER_LEFT	0x5b	// LEFT PLAYER + Shift
#	//#define KEY_PLAYER_RIGHT	0x5f	// RIGHT PLAYER + Shift
#	//#define KEY_INS	0x7b
#	//#define KEY_DEL	0x7f
#	
#	#define KEY_CURSOR_RIGHT	0xf0
#	#define KEY_CURSOR_LEFT	0xf1
#	#define KEY_CURSOR_UP	0xf2	// uUml + Alt
#	#define KEY_CURSOR_DOWN	0xf3	// aUml + Alt
#	#define KEY_BACKSPACE_X	0xf4	// oUml + Alt
#	
#	#define KEY_ANSWER	0x2b	// +/ANSWER (does not change with Shift)
#	#define KEY_ENTER	0x7c
#	
#	#define KEY_REPEAT	0x7e	// REPEAT/DELETE without modifiers
#	#define KEY_DELETE	0x5C	// REPEAT/DELETE + Shift
#	
#	#define KEY_ACTIVITY_1	0x01	// First activity selection foil button
#	#define KEY_ACTIVITY_2	0x02
#	#define KEY_ACTIVITY_3	0x03
#	#define KEY_ACTIVITY_4	0x04
#	#define KEY_ACTIVITY_5	0x05
#	#define KEY_ACTIVITY_6	0x06
#	#define KEY_ACTIVITY_7	0x07
#	#define KEY_ACTIVITY_8	0x08
#	#define KEY_ACTIVITY_9	0x09
#	#define KEY_ACTIVITY_10	0x0a
#	#define KEY_ACTIVITY_11	0x0b
#	#define KEY_ACTIVITY_12	0x0c
#	#define KEY_ACTIVITY_13	0x0d
#	#define KEY_ACTIVITY_14	0x0e
#	#define KEY_ACTIVITY_15	0x0f
#	#define KEY_ACTIVITY_16	0x10
#	#define KEY_ACTIVITY_17	0x11
#	#define KEY_ACTIVITY_18	0x12
#	#define KEY_ACTIVITY_19	0x13
#	#define KEY_ACTIVITY_20	0x14
#	#define KEY_ACTIVITY_21	0x15
#	#define KEY_ACTIVITY_22	0x16
#	#define KEY_ACTIVITY_23	0x17
#	#define KEY_ACTIVITY_24	0x18
#	#define KEY_ACTIVITY_25	0x19
#	#define KEY_ACTIVITY_26	0x1a
#	#define KEY_ACTIVITY_27	0x1b
#	#define KEY_ACTIVITY_28	0x1c
#	#define KEY_ACTIVITY_29	0x1d
#	#define KEY_ACTIVITY_30	0x1e
#	#define KEY_ACTIVITY_31	0x1f	// This is the last one they could fit below valid ASCII codes
#	#define KEY_ACTIVITY_32	0xB0	// This is where they continue (0xb0)
#	#define KEY_ACTIVITY_33	0xB1
#	#define KEY_ACTIVITY_34	0xB2
#	#define KEY_ACTIVITY_35	0xB3	// Last activity selection foil button
#	
#	#define KEY_POWER_OFF	0xB4	// OFF foil button
#	#define KEY_LEVEL	0xB5	// LEVEL foil button
#	#define KEY_PLAYERS	0xB6	// PLAYERS foil button
#	#define KEY_DISKETTE	0xB7	// DISKETTE foil button


#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__VGL'

PUBLIC `__VGL_KEY_STATUS_ADDRESS'
PUBLIC `__VGL_KEY_CURRENT_ADDRESS'

PUBLIC `__VGL_DISPLAY_COLS'
PUBLIC `__VGL_DISPLAY_ROWS'
PUBLIC `__VGL_DISPLAY_CONTROL_PORT'
PUBLIC `__VGL_DISPLAY_REFRESH_ADDRESS'
PUBLIC `__VGL_DISPLAY_CURSOR_X_ADDRESS'
PUBLIC `__VGL_DISPLAY_CURSOR_Y_ADDRESS'
PUBLIC `__VGL_DISPLAY_CURSOR_MODE_ADDRESS'
PUBLIC `__VGL_DISPLAY_CLEAR_ADDRESS'
PUBLIC `__VGL_DISPLAY_VRAM_START'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__VGL' = __VGL

defc `__VGL_KEY_STATUS_ADDRESS' = __VGL_KEY_STATUS_ADDRESS
defc `__VGL_KEY_CURRENT_ADDRESS' = __VGL_KEY_CURRENT_ADDRESS

defc `__VGL_DISPLAY_COLS' = __VGL_DISPLAY_COLS
defc `__VGL_DISPLAY_ROWS' = __VGL_DISPLAY_ROWS
defc `__VGL_DISPLAY_CONTROL_PORT' = __VGL_DISPLAY_CONTROL_PORT
defc `__VGL_DISPLAY_REFRESH_ADDRESS' = __VGL_DISPLAY_REFRESH_ADDRESS
defc `__VGL_DISPLAY_CURSOR_X_ADDRESS' = __VGL_DISPLAY_CURSOR_X_ADDRESS
defc `__VGL_DISPLAY_CURSOR_Y_ADDRESS' = __VGL_DISPLAY_CURSOR_Y_ADDRESS
defc `__VGL_DISPLAY_CURSOR_MODE_ADDRESS' = __VGL_DISPLAY_CURSOR_MODE_ADDRESS
defc `__VGL_DISPLAY_CLEAR_ADDRESS' = __VGL_DISPLAY_CLEAR_ADDRESS
defc `__VGL_DISPLAY_VRAM_START' = __VGL_DISPLAY_VRAM_START
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__VGL'
`#define' `__VGL'  __VGL

`#define' `__VGL_KEY_STATUS_ADDRESS'  __VGL_KEY_STATUS_ADDRESS
`#define' `__VGL_KEY_CURRENT_ADDRESS'  __VGL_KEY_CURRENT_ADDRESS

`#define' `__VGL_DISPLAY_COLS'  __VGL_DISPLAY_COLS
`#define' `__VGL_DISPLAY_ROWS'  __VGL_DISPLAY_ROWS
`#define' `__VGL_DISPLAY_CONTROL_PORT'  __VGL_DISPLAY_CONTROL_PORT
`#define' `__VGL_DISPLAY_REFRESH_ADDRESS'  __VGL_DISPLAY_REFRESH_ADDRESS
`#define' `__VGL_DISPLAY_CURSOR_X_ADDRESS'  __VGL_DISPLAY_CURSOR_X_ADDRESS
`#define' `__VGL_DISPLAY_CURSOR_Y_ADDRESS'  __VGL_DISPLAY_CURSOR_Y_ADDRESS
`#define' `__VGL_DISPLAY_CURSOR_MODE_ADDRESS'  __VGL_DISPLAY_CURSOR_MODE_ADDRESS
`#define' `__VGL_DISPLAY_CLEAR_ADDRESS'  __VGL_DISPLAY_CLEAR_ADDRESS
`#define' `__VGL_DISPLAY_VRAM_START'  __VGL_DISPLAY_VRAM_START
')
