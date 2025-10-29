
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC zx_01_input_lastk_stdio_msg_flsh

EXTERN zx_01_input_lastk_proc_lastk
EXTERN console_01_input_stdio_msg_flsh

zx_01_input_lastk_stdio_msg_flsh:

   call zx_01_input_lastk_proc_lastk
   jp z, console_01_input_stdio_msg_flsh   ; if LASTK = 0
   
   ld (hl),0                               ; clear any pending char
   jp console_01_input_stdio_msg_flsh      ; forward to library
