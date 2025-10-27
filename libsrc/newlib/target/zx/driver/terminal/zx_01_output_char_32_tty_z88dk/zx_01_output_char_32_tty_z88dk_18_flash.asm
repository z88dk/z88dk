
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_18_flash

zx_01_output_char_32_tty_z88dk_18_flash:

   ; change flash bit of foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   and $01
   rrca
   ld e,a
   
   ld a,(ix+23)                ; a = foreground colour
   and $7f
   
   or e
   ld (ix+23),a
   
   ret
