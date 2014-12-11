
; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_string

PUBLIC strcpy_callee

strcpy_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strcpy.asm"
