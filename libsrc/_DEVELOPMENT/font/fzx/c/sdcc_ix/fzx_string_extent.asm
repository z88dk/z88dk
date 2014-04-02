
; uint fzx_string_extent(char *s)

XDEF _fzx_string_extent

_fzx_string_extent:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_fzx_string_extent
   
   pop ix
   ret

   INCLUDE "font/fzx/z80/asm_fzx_string_extent.asm"
