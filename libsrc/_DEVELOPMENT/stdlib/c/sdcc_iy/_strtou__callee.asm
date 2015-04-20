
; unsigned int _strtou__callee(const char *nptr, char **endptr, int base)

SECTION code_stdlib

PUBLIC __strtou__callee

__strtou__callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm__strtou.asm"
