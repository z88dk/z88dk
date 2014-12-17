
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_22_at

EXTERN console_01_output_char_proc_snap
EXTERN console_01_output_char_proc_set_coord

zx_01_output_char_32_tty_22_at:

   ; at x,y
   
   ; de = parameters *

   ex de,hl
   
   ld d,(hl)                   ; d = y coord
   inc hl
   ld e,(hl)                   ; e = x coord
   
   call console_01_output_char_proc_snap
   jp console_01_output_char_proc_set_coord
