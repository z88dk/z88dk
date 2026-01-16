SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_tshr_draw_xor

__fzx_tshr_draw_xor:

   ; must not modify: ix, e, af', hl
   
   ; hl = screen address
   ; dca= bitmap bytes

   inc l                       ; advance two characters
   
   xor (hl)
   ld (hl),a                   ; third byte to screen
   
   dec l                       ; original position
   
   ld a,d
   xor (hl)
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
   xor (hl)
   ld (hl),a                   ; second byte to screen
   
   pop hl
   ret
