
; char *strcat(char * restrict s1, const char * restrict s2)

XDEF strcat

strcat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_strcat.asm"
