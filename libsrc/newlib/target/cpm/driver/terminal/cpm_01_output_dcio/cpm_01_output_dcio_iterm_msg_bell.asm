
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC cpm_01_output_dcio_iterm_msg_bell

EXTERN cpm_01_output_dcio_oterm_msg_bell_0

cpm_01_output_dcio_iterm_msg_bell:

   ;   can use:  af, bc, de, hl

   bit 1,(ix+7)
   ret z                       ; if signal bell is disabled

   jp cpm_01_output_dcio_oterm_msg_bell_0
