
; int strcasecmp(const char *s1, const char *s2)

XDEF strcasecmp, stricmp

strcasecmp:
stricmp:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_strcasecmp.asm"
