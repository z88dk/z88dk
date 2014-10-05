
; int fzx_write(void *buf, uint len)

SECTION seg_code_fzx

PUBLIC fzx_write_callee

fzx_write_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "font/fzx/common/z80/asm_fzx_write.asm"
