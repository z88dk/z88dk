
; long strtol_callee(const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_stdlib

PUBLIC _strtol_callee

_strtol_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdlib/z80/asm_strtol.asm"
