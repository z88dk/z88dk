
; uint fzx_buffer_extent(void *buf, uint len)

XDEF fzx_buffer_extent

fzx_buffer_extent:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_buffer_extent.asm"
