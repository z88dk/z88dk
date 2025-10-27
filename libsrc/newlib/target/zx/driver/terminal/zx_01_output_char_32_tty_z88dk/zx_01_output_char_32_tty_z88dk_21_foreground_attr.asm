
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_21_foreground_attr

zx_01_output_char_32_tty_z88dk_21_foreground_attr:

   ; change foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   ld (ix+23),a
   
   ret
