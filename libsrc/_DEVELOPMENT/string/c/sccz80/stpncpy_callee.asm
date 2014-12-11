
; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC stpncpy_callee

stpncpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_stpncpy.asm"
