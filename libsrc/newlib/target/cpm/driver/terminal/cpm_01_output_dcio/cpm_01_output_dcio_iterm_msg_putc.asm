
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC cpm_01_output_dcio_iterm_msg_putc

EXTERN cpm_01_output_dcio_oterm_msg_putc_raw

cpm_01_output_dcio_iterm_msg_putc:

   ; enter  :  c = char to output
   ; can use:  af, bc, de, hl, ix
   
   ; char to print is coming from the input terminal
   ; so it should not be subject to tty emulation
   
   ; input terminal must not echo control codes
   
   ld a,c
   cp 32
   jp nc, cpm_01_output_dcio_oterm_msg_putc_raw

   cp CHAR_LF
   jp z, cpm_01_output_dcio_oterm_msg_putc_raw

   ld c,'?'
   jp cpm_01_output_dcio_oterm_msg_putc_raw
