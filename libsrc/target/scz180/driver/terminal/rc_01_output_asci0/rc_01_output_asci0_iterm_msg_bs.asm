INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_asci0_iterm_msg_bs

EXTERN rc_01_output_asci0_oterm_msg_putc_send

rc_01_output_asci0_iterm_msg_bs:

   ; backspace
   ; can use:  af, bc, de, hl, ix

   call backspace

   ld c,' '
   call rc_01_output_asci0_oterm_msg_putc_send

backspace:

   ld c,CHAR_BS
   jp rc_01_output_asci0_oterm_msg_putc_send
