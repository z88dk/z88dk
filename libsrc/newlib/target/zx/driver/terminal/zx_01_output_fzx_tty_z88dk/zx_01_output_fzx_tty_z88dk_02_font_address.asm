
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_02_font_address

zx_01_output_fzx_tty_z88dk_02_font_address:

   ; de = parameters *

   ld a,(de)                   ; a = MSB font address
   inc de
   
   ld (ix+34),a
   
   ld a,(de)                   ; a = LSB of font address
   ld (ix+33),a
   
   ret
