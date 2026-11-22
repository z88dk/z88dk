
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_23_atr

zx_01_output_fzx_tty_z88dk_23_atr:

   ; atr dx,dy
   
   ; de = parameters *

   ld a,(de)                   ; biased dy
   inc de
   
   sub 0x80
   ld l,a
   add a,a
   sbc a,a
   ld h,a                      ; hl = dy
   
   ld a,(ix+37)                ; y
   add a,l
   ld (ix+37),a
   ld a,(ix+38)
   adc a,h
   ld (ix+38),a
   
   ld a,(de)                   ; biased dx
   
   sub 0x80
   ld l,a
   add a,a
   sbc a,a
   ld h,a                      ; hl = dx
   
   ld a,(ix+35)                ; x
   add a,l
   ld (ix+35),a
   ld a,(ix+36)
   adc a,h
   ld (ix+36),a
   
   ret
