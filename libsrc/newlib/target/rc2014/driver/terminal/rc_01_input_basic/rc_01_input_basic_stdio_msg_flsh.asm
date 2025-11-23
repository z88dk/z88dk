SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC rc_01_input_basic_stdio_msg_flsh

EXTERN console_01_input_stdio_msg_flsh

rc_01_input_basic_stdio_msg_flsh:
 
   ; get rid of any pending chars in basic's buffer
   
   rst 0x18                    ; nz if buffer contains chars
   jp z, console_01_input_stdio_msg_flsh
   
   rst 0x10                    ; read char and throw it away
   jr rc_01_input_basic_stdio_msg_flsh
