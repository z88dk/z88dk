
; uint fzx_string_extent(char *s)

XDEF fzx_string_extent

fzx_string_extent:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_fzx_string_extent
   
   pop ix
   ret

   INCLUDE "../../z80/asm_fzx_string_extent.asm"
