
; int strncasecmp(const char *s1, const char *s2, size_t n)

XDEF strncasecmp, strnicmp

strncasecmp:
strnicmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_strncasecmp.asm"
