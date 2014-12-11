
; int strcasecmp(const char *s1, const char *s2)

SECTION code_string

PUBLIC strcasecmp_callee

strcasecmp_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strcasecmp.asm"
