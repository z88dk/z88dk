SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC rc_01_output_sioa_iterm_msg_bell

EXTERN rc_01_output_sioa_oterm_msg_bell_0

rc_01_output_sioa_iterm_msg_bell:

   ;   can use:  af, bc, de, hl

   bit 1,(ix+7)
   ret z                       ; if signal bell is disabled

   jp rc_01_output_sioa_oterm_msg_bell_0
