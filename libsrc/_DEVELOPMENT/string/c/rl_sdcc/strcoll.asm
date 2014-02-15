
; int strcoll(const char *s1, const char *s2)

XDEF strcoll

strcoll:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_strcoll.asm"
