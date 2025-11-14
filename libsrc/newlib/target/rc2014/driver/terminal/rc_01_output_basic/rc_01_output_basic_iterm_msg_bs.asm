INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_basic_iterm_msg_bs

rc_01_output_basic_iterm_msg_bs:

   ; backspace
   ; can use:  af, bc, de, hl, ix

   call backspace

   ld a,' '
   rst 0x08

backspace:

   ld a,CHAR_BS
   jp 0x08
