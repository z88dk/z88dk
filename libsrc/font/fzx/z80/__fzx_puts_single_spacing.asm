
SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_puts_single_spacing

__fzx_puts_single_spacing:

   ; enter : ix = struct fzx_state *
   ;
   ; exit  : de = font_height
   ;         hl = y + font_height
   ;
   ; uses  : f, de, hl
   
   ld l,(ix+3)
   ld h,(ix+4)                 ; hl = struct fzx_font *
   
   ld e,(hl)
   ld d,0                      ; de = font height
   
   ld l,(ix+7)
   ld h,(ix+8)                 ; hl = fzx_state.y
   
   add hl,de
   ret
