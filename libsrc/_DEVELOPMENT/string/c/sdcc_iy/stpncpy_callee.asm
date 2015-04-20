
; char *stpncpy_callee(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC _stpncpy_callee

_stpncpy_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "string/z80/asm_stpncpy.asm"
