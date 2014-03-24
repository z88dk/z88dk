
; void *fzx_buffer_partition(void *buf, uint len, uint width)

XDEF fzx_buffer_partition_callee

fzx_buffer_partition_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_buffer_partition.asm"
