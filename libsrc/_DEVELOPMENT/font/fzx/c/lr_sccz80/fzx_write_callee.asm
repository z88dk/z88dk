
; int fzx_write(void *buf, uint len)

XDEF fzx_write_callee

fzx_write_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_fzx_write.asm"
