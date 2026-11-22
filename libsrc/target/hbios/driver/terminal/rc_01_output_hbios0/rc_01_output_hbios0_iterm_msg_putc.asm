INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_hbios0_iterm_msg_putc

EXTERN rc_01_output_hbios0_oterm_msg_putc_raw

rc_01_output_hbios0_iterm_msg_putc:

   ; enter  :  c = char to output
   ; can use:  af, bc, de, hl, ix
   
   ; char to print is coming from the input terminal
   ; so it should not be subject to tty emulation
   
   ; input terminal must not echo control codes
   
   ld a,c
   cp 32
   jp nc, rc_01_output_hbios0_oterm_msg_putc_raw

   cp CHAR_LF
   jp z, rc_01_output_hbios0_oterm_msg_putc_raw

   ld c,'?'
   jp rc_01_output_hbios0_oterm_msg_putc_raw
