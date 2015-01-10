
; BSD
; void bzero(void *mem, int bytes)

SECTION code_string

PUBLIC _bzero

_bzero:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "string/z80/asm_bzero.asm"
