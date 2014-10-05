
; int fzx_write(void *buf, uint len)

SECTION seg_code_fzx

PUBLIC _fzx_write

_fzx_write:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_write.asm"
