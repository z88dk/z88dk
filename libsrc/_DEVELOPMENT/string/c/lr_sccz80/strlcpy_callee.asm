
; size_t strlcpy(char * restrict s1, const char * restrict s2, size_t n)

XDEF strlcpy_callee

strlcpy_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "../../z80/asm_strlcpy.asm"
