divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Model specific target config for
# V-Tech Genius Leader 4000q / 4004ql

define(`__VGL_MODEL_NUMBER', 4000)

define(`__VGL_DISPLAY_COLS', 20)
define(`__VGL_DISPLAY_ROWS', 4)

define(`__VGL_DISPLAY_CONTROL_PORT', 0x0a)
define(`__VGL_DISPLAY_VRAM_START', 0xdca0)
define(`__VGL_DISPLAY_REFRESH_ADDRESS', 0xdcf0)      #0xdcf0...0xdcf3 for each of the 4 rows
define(`__VGL_DISPLAY_CURSOR_X_ADDRESS', 0xdcf4)
define(`__VGL_DISPLAY_CURSOR_Y_ADDRESS', 0xdcf5)
define(`__VGL_DISPLAY_CURSOR_OFS_ADDRESS', -1)       # Not available on MODEL4000
define(`__VGL_DISPLAY_CURSOR_MODE_ADDRESS', 0xdcf6)
define(`__VGL_DISPLAY_CLEAR_ADDRESS', 0xdcf7)        # Can be set to 0 or 1

define(`__VGL_KEY_STATUS_ADDRESS', 0xdb00)
define(`__VGL_KEY_CURRENT_ADDRESS', 0xdb01)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)
