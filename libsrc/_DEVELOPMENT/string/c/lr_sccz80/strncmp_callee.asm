
; int strncmp(const char *s1, const char *s2, size_t n)

PUBLIC strncmp_callee

strncmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strncmp.asm"
