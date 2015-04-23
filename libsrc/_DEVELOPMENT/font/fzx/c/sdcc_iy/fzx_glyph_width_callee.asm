
; uint16_t fzx_glyph_width_callee(struct fzx_font *ff, int c)

SECTION code_font_fzx

PUBLIC _fzx_glyph_width_callee, l0_fzx_glyph_width_callee

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

   INCLUDE "font/fzx/z80/asm_fzx_glyph_width.asm"
