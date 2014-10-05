
; uint fzx_buffer_extent(void *buf, uint len)

SECTION seg_code_fzx

PUBLIC _fzx_buffer_extent

_fzx_buffer_extent:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "font/fzx/common/z80/asm_fzx_buffer_extent.asm"
