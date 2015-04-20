
; char *strtok_r_callee(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_string

PUBLIC _strtok_r_callee

_strtok_r_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strtok_r.asm"
