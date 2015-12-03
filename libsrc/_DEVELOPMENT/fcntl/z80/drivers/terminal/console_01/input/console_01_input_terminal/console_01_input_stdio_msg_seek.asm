
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_stdio_msg_seek

EXTERN character_00_input_stdio_msg_seek

defc console_01_input_stdio_msg_seek = character_00_input_stdio_msg_seek

   ;    C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ; DEHL'= file offset
   ;    C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ;
   ; return:
   ;
   ; DEHL = updated file position
   ; carry set on error (file position out of range)
   ; 
   ; note: stdio stages with buffers must flush first when
   ; this message is received.
