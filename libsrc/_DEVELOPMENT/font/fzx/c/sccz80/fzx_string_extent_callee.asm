
; uint16_t fzx_string_extent(struct fzx_font *ff, char *s)

SECTION code_font_fzx

PUBLIC fzx_string_extent_callee

fzx_string_extent_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "font/fzx/z80/asm_fzx_string_extent.asm"
