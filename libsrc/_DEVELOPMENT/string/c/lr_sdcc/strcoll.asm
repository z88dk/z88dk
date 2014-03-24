
; int strcoll(const char *s1, const char *s2)

XDEF strcoll

strcoll:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strcoll.asm"
