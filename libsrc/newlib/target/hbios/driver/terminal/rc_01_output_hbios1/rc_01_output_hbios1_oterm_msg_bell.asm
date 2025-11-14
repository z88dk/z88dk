INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_hbios1_oterm_msg_bell
PUBLIC rc_01_output_hbios1_oterm_msg_bell_0

EXTERN rc_01_output_hbios1_oterm_msg_putc_send

rc_01_output_hbios1_oterm_msg_bell:

   ;   can use:  af, bc, de, hl

   bit 0,(ix+7)
   ret z                       ; if bell disabled

rc_01_output_hbios1_oterm_msg_bell_0:

   ld c,CHAR_BELL
   jp rc_01_output_hbios1_oterm_msg_putc_send
