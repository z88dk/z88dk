
; char *strnset_callee(char *s, int c, size_t n)

SECTION code_string

PUBLIC _strnset_callee

_strnset_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strnset.asm"
