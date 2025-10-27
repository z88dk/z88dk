
; uint16_t fzx_glyph_width(struct fzx_font *ff, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_glyph_width

EXTERN fzx0_glyph_width_callee

fzx_glyph_width:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp fzx0_glyph_width_callee
