
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_z88dk_28_left

EXTERN console_01_output_char_proc_get_coord
EXTERN console_01_output_char_proc_snap
EXTERN console_01_output_char_proc_set_coord

zx_01_output_char_32_tty_z88dk_28_left:

   ; move cursor left
   
   call console_01_output_char_proc_get_coord
   
   dec e                       ; x--
   
   call console_01_output_char_proc_snap
   jp console_01_output_char_proc_set_coord
