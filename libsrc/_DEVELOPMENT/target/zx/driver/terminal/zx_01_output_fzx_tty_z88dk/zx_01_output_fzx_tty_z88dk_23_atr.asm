
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_23_atr

zx_01_output_fzx_tty_z88dk_23_atr:

   ; atr dx,dy
   
   ; de = parameters *
   
   ld a,(de)                   ; a = dy
   inc de
   
   ld c,a
   
   add a,a
   sbc a,a
   
   ld b,a                      ; bc = dy
   
   ld l,(ix+37)
   ld h,(ix+38)                ; hl = y
   
   add hl,bc
   
   ld (ix+37),l
   ld (ix+38),h                ; set new y
   
   ld a,(de)                   ; a = dx
   
   ld c,a
   
   add a,a
   sbc a,a
   
   ld b,a                      ; bc = dx
   
   ld l,(ix+35)
   ld h,(ix+36)                ; hl = x
   
   add hl,bc
   
   ld (ix+35),l
   ld (ix+36),h                ; set new x
   
   ret
