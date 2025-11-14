
; uint16_t fzx_glyph_width(struct fzx_font *ff, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_glyph_width_callee, fzx0_glyph_width_callee

EXTERN asm_fzx_glyph_width

fzx_glyph_width_callee:

   pop hl
   pop bc
   ex (sp),hl

fzx0_glyph_width_callee:

   ld a,c
   call asm_fzx_glyph_width
   
   ld l,a
   ld h,0
   
   inc hl
   ret
