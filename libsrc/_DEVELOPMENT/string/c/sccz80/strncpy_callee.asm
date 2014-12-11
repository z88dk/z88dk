
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_string

PUBLIC strncpy_callee

strncpy_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strncpy.asm"
