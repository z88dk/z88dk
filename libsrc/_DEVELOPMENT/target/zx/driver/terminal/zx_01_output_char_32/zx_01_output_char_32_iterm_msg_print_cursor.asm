
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_iterm_msg_print_cursor

EXTERN console_01_output_char_oterm_msg_putc_raw

zx_01_output_char_32_iterm_msg_print_cursor:

   ; enter  :  c = cursor char (CHAR_CURSOR_UC or CHAR_CURSOR_LC)
   ; can use: af, bc, de, hl, ix
   
   ; change cursor to flashing 'C' or flashing 'L'
   
   ld a,c
   
   ld c,'C'
   
   cp CHAR_CURSOR_UC
   jr z, cursor

   ld c,'L'

cursor:

   ld b,(ix+23)                ; b = foreground colour
   set 7,b                     ; make it flash

   jp console_01_output_char_oterm_msg_putc_raw
