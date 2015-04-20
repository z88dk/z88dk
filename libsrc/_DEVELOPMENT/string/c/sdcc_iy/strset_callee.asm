
; char* strset_callee(char *s, int c)

SECTION code_string

PUBLIC _strset_callee

_strset_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strset.asm"
