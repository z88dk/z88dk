
; uint fzx_string_extent(char *s)

SECTION code_font_fzx

PUBLIC _fzx_string_extent

_fzx_string_extent:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "font/fzx/zx/z80/asm_fzx_string_extent.asm"
