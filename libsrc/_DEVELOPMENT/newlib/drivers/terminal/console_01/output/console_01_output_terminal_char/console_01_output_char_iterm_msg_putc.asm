
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_iterm_msg_putc

EXTERN console_01_output_char_oterm_msg_putc_raw

console_01_output_char_iterm_msg_putc:

   ; enter  :  c = char to output
   ; can use:  af, bc, de, hl, ix
   
   ; char to print is coming from the input terminal
   ; so it should not be subject to tty emulation
   
   ld b,255                    ; b = parameter (undefined)
   
   ; input terminal must not echo control codes
   
   ld a,c
   cp 32
   jp nc, console_01_output_char_oterm_msg_putc_raw

   cp CHAR_LF
   jp z, console_01_output_char_oterm_msg_putc_raw

   ld c,'?'
   jp console_01_output_char_oterm_msg_putc_raw
