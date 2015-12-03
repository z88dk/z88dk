
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_stdio_msg_read

EXTERN character_00_input_stdio_msg_read

defc console_01_input_stdio_msg_read = character_00_input_stdio_msg_read

   ; DE'= void *buffer = byte destination
   ; BC'= max_length > 0
   ; HL = max_length > 0
   ;
   ; return:
   ;
   ; BC = number of bytes successfully read
   ; DE'= void *buffer_ptr = address of byte following last written
   ; 
   ; carry set on error with HL=0 for stream err, HL=-1 for eof
