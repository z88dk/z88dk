
; BSD
; void bzero_callee(void *mem, int bytes)

SECTION code_string

PUBLIC _bzero_callee

_bzero:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_bzero.asm"
