
; uint fzx_buffer_extent(void *buf, uint len)

XDEF fzx_buffer_extent

LIB asm_fzx_buffer_extent

fzx_buffer_extent:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_fzx_buffer_extent
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fzx_buffer_extent.asm"
