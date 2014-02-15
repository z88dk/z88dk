
; char *strstr(const char *s1, const char *s2)

XDEF strstr

strstr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_strstr.asm"
