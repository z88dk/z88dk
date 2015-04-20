
; long strtol_callee( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_stdlib

PUBLIC _strtol_callee, l0_strtol_callee

_strtol_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_strtol_callee:

   push ix
   
   call asm_strtol
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_strtol.asm"
