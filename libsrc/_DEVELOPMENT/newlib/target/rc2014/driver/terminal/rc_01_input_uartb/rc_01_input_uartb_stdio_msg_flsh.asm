SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_uartb_stdio_msg_flsh

EXTERN _uartb_flush_rx_di
EXTERN console_01_input_stdio_msg_flsh

rc_01_input_uartb_stdio_msg_flsh:

   ; get rid of any pending chars in the uartb buffer

   call _uartb_flush_rx_di
   jp console_01_input_stdio_msg_flsh
