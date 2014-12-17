
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_30_up

EXTERN console_01_output_char_proc_get_coord
EXTERN console_01_output_char_proc_snap
EXTERN console_01_output_char_proc_set_coord

zx_01_output_char_32_tty_30_up:

   ; move cursor up
   
   call console_01_output_char_proc_get_coord
   
   dec d                       ; y--
   
   call console_01_output_char_proc_snap
   jp console_01_output_char_proc_set_coord
