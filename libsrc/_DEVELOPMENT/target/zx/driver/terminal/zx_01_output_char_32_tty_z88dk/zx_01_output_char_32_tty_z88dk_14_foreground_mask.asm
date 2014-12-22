
SECTION code_fcntl

PUBLIC zx_01_output_char_32_tty_z88dk_14_foreground_mask

zx_01_output_char_32_tty_z88dk_14_foreground_mask:

   ; change the mask applied to the foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   ld (ix+24),a
   
   ret
