
SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_draw_or

__fzx_draw_or:

   ; must not modify: ix, b, e, af', hl
   
   ; hl = screen address
   ; dca= bitmap bytes

   inc l
   inc l
   
   or (hl)
   ld (hl),a                   ; third byte to screen
   
   dec l
   
   ld a,c
   or (hl)
   ld (hl),a                   ; second byte to screen
   
   dec l
   
   ld a,d
   or (hl)
   ld (hl),a                   ; first byte to screen
   
   ret
