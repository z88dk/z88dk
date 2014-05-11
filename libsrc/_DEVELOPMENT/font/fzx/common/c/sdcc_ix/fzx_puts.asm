
; int fzx_puts(char *s)

PUBLIC _fzx_puts

_fzx_puts:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_fzx_puts
   
   pop ix
   ret

   INCLUDE "font/fzx/common/z80/asm_fzx_puts.asm"
