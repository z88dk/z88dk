
; int fzx_write(void *buf, uint len)

PUBLIC _fzx_write

_fzx_write:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "font/fzx/common/z80/asm_fzx_write.asm"
