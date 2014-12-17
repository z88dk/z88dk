
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_31_down

EXTERN console_01_output_char_proc_get_coord
EXTERN console_01_output_char_proc_snap
EXTERN console_01_output_char_proc_set_coord

zx_01_output_char_32_tty_31_down:

   ; move cursor left
   
   call console_01_output_char_proc_get_coord
   
   inc d                       ; y++
   
   call console_01_output_char_proc_snap
   jp console_01_output_char_proc_set_coord
