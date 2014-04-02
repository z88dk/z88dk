
; uint fzx_buffer_extent(void *buf, uint len)

XDEF _fzx_buffer_extent

_fzx_buffer_extent:

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
   
   INCLUDE "font/fzx/z80/asm_fzx_buffer_extent.asm"
