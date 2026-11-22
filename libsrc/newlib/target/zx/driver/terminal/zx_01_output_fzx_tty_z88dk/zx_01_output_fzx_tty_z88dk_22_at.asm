
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_22_at

zx_01_output_fzx_tty_z88dk_22_at:

   ; at x,y
   
   ; de = parameters *

   ld l,0
   
do_y:

   ld a,(de)                   ; biased y
   inc de
   
   inc a
   jr z, do_x                  ; skip if -1 (means x=254 not allowed)
   
   dec a
   dec a
   
   ld (ix+37),a                ; set y
   ld (ix+38),l
   
do_x:

   ld a,(de)                   ; biased x
   
   inc a
   ret z                       ; skip if -1 (means y=254 not allowed)
   
   dec a
   dec a
   
   ld (ix+35),a                ; set x
   ld (ix+36),l
   
   ret
