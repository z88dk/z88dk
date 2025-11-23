
SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_draw_xor

__fzx_draw_xor:

   ; must not modify: ix, b, e, af', hl
   
   ; hl = screen address
   ; dca= bitmap bytes

   inc l
   inc l
   
   xor (hl)
   ld (hl),a                   ; third byte to screen
   
   dec l
   
   ld a,c
   xor (hl)
   ld (hl),a                   ; second byte to screen
   
   dec l
   
   ld a,d
   xor (hl)
   ld (hl),a                   ; first byte to screen
   
   ret
