
; size_t strcspn(const char *s1, const char *s2)

XDEF strcspn

strcspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strcspn.asm"
