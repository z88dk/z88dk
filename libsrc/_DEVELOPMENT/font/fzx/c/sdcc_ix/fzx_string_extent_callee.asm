
; uint16_t fzx_string_extent_callee(struct fzx_font *ff, char *s)

SECTION code_font_fzx

PUBLIC _fzx_string_extent_callee

_fzx_string_extent_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_string_extent.asm"
