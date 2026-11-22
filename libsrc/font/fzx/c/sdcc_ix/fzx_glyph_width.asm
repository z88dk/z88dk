
; uint16_t fzx_glyph_width(struct fzx_font *ff, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_glyph_width

EXTERN l0_fzx_glyph_width_callee

_fzx_glyph_width:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_fzx_glyph_width_callee
