
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_20_inverse

zx_01_output_char_32_tty_z88dk_20_inverse:

   ; swap paper and ink in foreground colour

   ld e,(ix+23)                ; e = foreground colour
   
   ld a,e
   and $07
   add a,a
   add a,a
   add a,a
   
   ld c,a                      ; c = ink bits in paper position
   
   ld a,e
   rra
   rra
   rra
   and $07
   
   ld b,a                      ; b = paper bits in ink position
   
   ld a,e
   and $c0
   or b
   or c
   
   ld (ix+23),a
   ret
