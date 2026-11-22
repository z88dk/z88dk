
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_16_ink

zx_01_output_char_32_tty_z88dk_16_ink:

   ; change ink of foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   and $07
   ld e,a
   
   ld a,(ix+23)                ; a = foreground colour
   and $f8
   
   or e
   ld (ix+23),a
   
   ret
