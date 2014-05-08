
; int strcasecmp(const char *s1, const char *s2)

PUBLIC strcasecmp_callee, stricmp_callee

strcasecmp_callee:
stricmp_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strcasecmp.asm"
