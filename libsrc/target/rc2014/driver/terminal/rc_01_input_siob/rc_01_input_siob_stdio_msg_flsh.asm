SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_siob_stdio_msg_flsh

EXTERN _siob_flush_Rx_di
EXTERN console_01_input_stdio_msg_flsh

rc_01_input_siob_stdio_msg_flsh:
 
   ; get rid of any pending chars in the siob buffer
   
   call _siob_flush_Rx_di
   jp console_01_input_stdio_msg_flsh
