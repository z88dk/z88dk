
; char *strcpy(char * restrict s1, const char * restrict s2)

XDEF strcpy

strcpy:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_strcpy.asm"
