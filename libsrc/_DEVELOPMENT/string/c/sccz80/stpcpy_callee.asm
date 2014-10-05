
; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION seg_code_string

PUBLIC stpcpy_callee

stpcpy_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_stpcpy.asm"
