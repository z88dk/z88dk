
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_22_at

zx_01_output_char_32_tty_z88dk_22_at:

   ; at x,y
   
   ; de = parameters *

do_y:

   ld a,(de)                   ; biased y coord
   inc de
   
   inc a
   jr z, do_x                  ; skip if -1

   dec a
   dec a
   
   ld (ix+15),a                ; set y coord

do_x:

   ld a,(de)                   ; biased x coord
   
   inc a
   ret z                       ; skip if -1
   
   dec a
   dec a
   
   ld (ix+14),a                ; set x coord
   
   ret
