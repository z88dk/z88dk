
; unsigned long strtoul_callee( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC _strtoul_callee, l0_strtoul_callee

EXTERN asm_strtoul

_strtoul_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_strtoul_callee:
   
   push ix
   
   call asm_strtoul
   
   pop ix
   ret
