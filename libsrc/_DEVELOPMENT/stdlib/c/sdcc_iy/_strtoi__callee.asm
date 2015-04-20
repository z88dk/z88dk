
; int _strtoi__callee(const char *nptr, char **endptr, int base)

SECTION code_stdlib

PUBLIC __strtoi__callee

__strtoi__callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm__strtoi.asm"
