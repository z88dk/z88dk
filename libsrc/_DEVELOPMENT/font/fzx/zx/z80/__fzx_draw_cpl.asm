
SECTION code_font_fzx

PUBLIC __fzx_draw_cpl

__fzx_draw_cpl:

   ; must not modify: ix, b, e, af', hl
   
   ; hl = screen address
   ; dca= bitmap bytes

   inc l
   inc l
   
   cpl
   or (hl)
   ld (hl),a                   ; third byte to screen
   
   dec l
   
   ld a,c
   cpl
   or (hl)
   ld (hl),a                   ; second byte to screen
   
   dec l
   
   ld a,d
   cpl
   or (hl)
   ld (hl),a                   ; first byte to screen
   
   ret
