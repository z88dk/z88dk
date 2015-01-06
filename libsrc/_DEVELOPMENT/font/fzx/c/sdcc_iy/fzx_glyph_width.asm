
; uint16_t fzx_glyph_width(struct fzx_font *ff, int c)

SECTION code_font_fzx

PUBLIC _fzx_glyph_width

_fzx_glyph_width:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   ld a,c
   call asm_fzx_glyph_width
   
   ld l,a
   ld h,0
   
   inc hl
   ret

   INCLUDE "font/fzx/z80/asm_fzx_glyph_width.asm"
