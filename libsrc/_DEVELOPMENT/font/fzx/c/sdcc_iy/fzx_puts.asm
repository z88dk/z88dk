
; int fzx_puts(char *s)

XDEF _fzx_puts

_fzx_puts:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "font/fzx/z80/asm_fzx_puts.asm"
