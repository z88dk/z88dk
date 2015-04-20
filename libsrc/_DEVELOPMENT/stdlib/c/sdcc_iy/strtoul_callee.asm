
; unsigned long strtoul_callee( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_stdlib

PUBLIC _strtoul_callee

_strtoul_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

   INCLUDE "stdlib/z80/asm_strtoul.asm"
