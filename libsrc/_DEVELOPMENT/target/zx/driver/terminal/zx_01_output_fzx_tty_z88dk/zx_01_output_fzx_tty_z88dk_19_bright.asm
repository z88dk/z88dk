
SECTION code_fcntl

PUBLIC zx_01_output_fzx_tty_z88dk_19_bright

zx_01_output_fzx_tty_z88dk_19_bright:

   ; change bright bit of foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   and $01
   rrca
   rrca
   ld e,a
   
   ld a,(ix+52)                ; a = foreground colour
   and $bf
   
   or e
   ld (ix+52),a
   
   ret
