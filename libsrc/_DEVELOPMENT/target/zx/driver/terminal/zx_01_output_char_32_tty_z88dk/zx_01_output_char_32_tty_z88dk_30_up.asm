
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_30_up

EXTERN console_01_output_char_proc_move_up

zx_01_output_char_32_tty_z88dk_30_up:

   ; move cursor up
   
   ld d,(ix+15)                ; d = y coord
   ld b,(ix+19)                ; b = window.height

   call console_01_output_char_proc_move_up
   
   ld (ix+15),d                ; store y coord
   ret
