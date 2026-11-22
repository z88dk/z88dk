SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_tshr_draw_reset

__fzx_tshr_draw_reset:

   ; must not modify: ix, e, af', hl
   
   ; hl = screen address
   ; dca= bitmap bytes

   inc l                       ; advance two characters
   
   cpl
   and (hl)
   ld (hl),a                   ; third byte to screen
   
   dec l                       ; original position
   
   ld a,d
   cpl
   and (hl)
   ld (hl),a                   ; first byte to screen
   
   push hl
   
   ld a,$20
   xor h
   ld h,a                      ; advance one character
   
   and $20
   jr nz, plot
   inc l

plot:

   ld a,c
   cpl
   and (hl)
   ld (hl),a                   ; second byte to screen
   
   pop hl
   ret
