
SECTION code_font
SECTION code_font_fzx

PUBLIC __fzx_string_glyph_width

EXTERN asm_fzx_glyph_width

__fzx_string_glyph_width:

   push hl                     ; save allowed width
   
   push ix
   pop hl                      ; hl = struct fzx_font *
   
   call asm_fzx_glyph_width
   
   inc a
   add a,(ix+1)                ; a = glyph width + tracking
   
   pop hl                      ; hl = allowed width
   
   ld c,a
   ld b,0
   
   sbc hl,bc
   ret
