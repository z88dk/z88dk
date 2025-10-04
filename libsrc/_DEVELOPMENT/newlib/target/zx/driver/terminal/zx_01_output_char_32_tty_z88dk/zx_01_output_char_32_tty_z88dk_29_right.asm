
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_29_right

EXTERN console_01_output_char_proc_move_right

zx_01_output_char_32_tty_z88dk_29_right:

   ; move cursor right
   
   ld e,(ix+14)                ; e = x coord
   ld d,(ix+15)                ; d = y coord
   
   ld c,(ix+17)                ; c = window.width
   ld b,(ix+19)                ; b = window.height
   
   call console_01_output_char_proc_move_right
   
   ld (ix+14),e                ; store x coord
   ld (ix+15),d                ; store y coord

   ret
