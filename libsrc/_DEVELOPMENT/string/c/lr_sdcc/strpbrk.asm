
; char *strpbrk(const char *s1, const char *s2)

XDEF strpbrk

strpbrk:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_strpbrk.asm"
