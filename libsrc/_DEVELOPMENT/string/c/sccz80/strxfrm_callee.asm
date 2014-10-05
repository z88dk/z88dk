
; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)

SECTION seg_code_string

PUBLIC strxfrm_callee

strxfrm_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strxfrm.asm"
