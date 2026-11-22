SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_tshr_draw_or

__fzx_tshr_draw_or:

   ; must not modify: ix, e, af', hl
   
   ; hl = screen address
   ; dca= bitmap bytes

   inc l                       ; advance two characters
   
   or (hl)
   ld (hl),a                   ; third byte to screen
   
   dec l                       ; original position
   
   ld a,d
   or (hl)
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
   or (hl)
   ld (hl),a                   ; second byte to screen
   
   pop hl
   ret
