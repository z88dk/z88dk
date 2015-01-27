
SECTION code_fcntl

PUBLIC zx_01_output_fzx_tty_z88dk_18_flash

zx_01_output_fzx_tty_z88dk_18_flash:

   ; change flash bit of foreground colour
   
   ; de = parameters *
   
   ld a,(de)
   and $01
   rrca
   ld e,a
   
   ld a,(ix+52)                ; a = foreground colour
   and $7f
   
   or e
   ld (ix+52),a
   
   ret
