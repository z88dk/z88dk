SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC term_01_input_char_stdio_msg_flsh

EXTERN console_01_input_stdio_msg_flsh

term_01_input_char_stdio_msg_flsh:
 
   ; get rid of any pending chars in the hardware

error implement term_01_input_char_stdio_msg_flsh

   ; then forward the message to the library so it
   ; can flush its buffer
   
   jp console_01_input_stdio_msg_flsh
