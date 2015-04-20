
; char *strtok_callee(char * restrict s1, const char * restrict s2)

SECTION code_string

PUBLIC _strtok_callee

_strtok_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strtok.asm"
