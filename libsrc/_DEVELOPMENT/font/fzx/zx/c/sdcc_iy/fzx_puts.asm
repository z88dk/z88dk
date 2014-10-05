
; int fzx_puts(char *s)

SECTION seg_code_fzx

PUBLIC _fzx_puts

_fzx_puts:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "font/fzx/zx/z80/asm_fzx_puts.asm"
