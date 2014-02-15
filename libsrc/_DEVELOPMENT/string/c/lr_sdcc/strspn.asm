
; size_t strspn(const char *s1, const char *s2)

XDEF strspn

strspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_strspn.asm"
