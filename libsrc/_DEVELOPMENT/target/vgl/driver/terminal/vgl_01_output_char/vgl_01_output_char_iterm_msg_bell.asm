
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_char_iterm_msg_bell
EXTERN vgl_01_output_char_oterm_msg_bell


vgl_01_output_char_iterm_msg_bell:
   jp vgl_01_output_char_oterm_msg_bell
