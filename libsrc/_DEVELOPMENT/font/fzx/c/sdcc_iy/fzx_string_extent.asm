
; uint fzx_string_extent(char *s)

XDEF fzx_string_extent

fzx_string_extent:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "font/fzx/z80/asm_fzx_string_extent.asm"
