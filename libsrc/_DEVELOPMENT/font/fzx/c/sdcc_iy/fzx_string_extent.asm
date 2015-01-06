
; uint16_t fzx_string_extent(struct fzx_font *ff, char *s)

SECTION code_font_fzx

PUBLIC _fzx_string_extent

_fzx_string_extent:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_string_extent.asm"
