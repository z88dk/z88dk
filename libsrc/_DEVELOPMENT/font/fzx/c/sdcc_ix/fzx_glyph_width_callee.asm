
; uint16_t fzx_glyph_width_callee(struct fzx_font *ff, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_glyph_width_callee, l0_fzx_glyph_width_callee

EXTERN asm_fzx_glyph_width

_fzx_glyph_width_callee:

   pop af
   pop hl
   pop bc
   push af

l0_fzx_glyph_width_callee:

   ld a,c
   call asm_fzx_glyph_width
   
   ld l,a
   ld h,0
   
   inc hl
   ret
