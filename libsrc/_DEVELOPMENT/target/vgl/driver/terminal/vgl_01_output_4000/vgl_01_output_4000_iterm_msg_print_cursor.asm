
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_4000_iterm_msg_print_cursor

vgl_01_output_4000_iterm_msg_print_cursor:
   ; enter  :  c = cursor char (CHAR_CURSOR_UC or CHAR_CURSOR_LC)
   ; can use: af, bc, de, hl, ix
   
   ; change cursor to flashing 'C' or flashing 'L'
   
   ld a, 1  ;0=off, 1=block 2=line
   ld (__VGL_4000_DISPLAY_CURSOR_MODE_ADDRESS), a
   
   ;@TODO: Switch cursor on using port 0x0a
   
   ret
