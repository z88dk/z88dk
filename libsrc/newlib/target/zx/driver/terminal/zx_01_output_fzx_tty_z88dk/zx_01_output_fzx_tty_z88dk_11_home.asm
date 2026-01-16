
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_11_home

zx_01_output_fzx_tty_z88dk_11_home:

   ; move cursor to (0,0)
   
   ld hl,0
   
   ld (ix+35),l
   ld (ix+36),h                ; x = 0
   
   ld (ix+37),l
   ld (ix+38),h                ; y = 0
   
   ret

