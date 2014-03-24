
; void *fzx_buffer_partition_ww(void *buf, uint len, uint width)

XDEF fzx_buffer_partition_ww

fzx_buffer_partition_ww:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   push ix
   
   call asm_fzx_partition_ww
   
   pop ix
   ret
   
   INCLUDE "font/fzx/z80/asm_fzx_buffer_partition_ww.asm"
