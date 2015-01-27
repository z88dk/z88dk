
SECTION code_fcntl

PUBLIC zx_01_output_fzx_tty_z88dk_16_ink

zx_01_output_fzx_tty_z88dk_16_ink:

   ; change ink of foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   and $07
   ld e,a
   
   ld a,(ix+52)                ; a = foreground colour
   and $f8
   
   or e
   ld (ix+52),a
   
   ret
