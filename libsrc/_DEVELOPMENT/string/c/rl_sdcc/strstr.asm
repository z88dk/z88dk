
; char *strstr(const char *s1, const char *s2)

XDEF strstr

strstr:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strstr.asm"
