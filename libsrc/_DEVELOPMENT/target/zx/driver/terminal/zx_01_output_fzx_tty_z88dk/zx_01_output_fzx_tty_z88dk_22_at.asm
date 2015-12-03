
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_22_at

zx_01_output_fzx_tty_z88dk_22_at:

   ; at x,y
   
   ; de = parameters *

   ex de,hl
   
   ld e,(hl)                   ; e = y coord
   inc hl
   ld l,(hl)                   ; l = x coord

   xor a
   
   ld d,a
   ld h,a
   
   ld (ix+35),l
   ld (ix+36),h                ; set x coord
   
   ex de,hl
   
   ld (ix+37),l
   ld (ix+38),h                ; set y coord
   
   ret
