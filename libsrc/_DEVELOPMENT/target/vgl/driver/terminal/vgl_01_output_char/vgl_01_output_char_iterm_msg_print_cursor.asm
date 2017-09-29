
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_char_iterm_msg_print_cursor

vgl_01_output_char_iterm_msg_print_cursor:
   ; enter  :  c = cursor char (CHAR_CURSOR_UC or CHAR_CURSOR_LC)
   ; can use: af, bc, de, hl, ix
   
   ; change cursor to flashing 'C' or flashing 'L'
   
   ;; Set cursor position
   ;ld a, (ix+14)    ; in FD struct
   ;ld (__VGL_DISPLAY_CURSOR_X_ADDRESS), a
   ;ld a, (ix+15)    ; in FD struct
   ;ld (__VGL_DISPLAY_CURSOR_Y_ADDRESS), a
   ; ...
   ;ld (__VGL_DISPLAY_CURSOR_OFS_ADDRESS), a
   
   ld a, 1  ;0=off, 1=block 2=line
   ld (__VGL_DISPLAY_CURSOR_MODE_ADDRESS), a
   
   ;@TODO: Switch cursor on using port 0x0a
   
   
   ret
