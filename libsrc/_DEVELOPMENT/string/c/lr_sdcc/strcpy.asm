
; char *strcpy(char * restrict s1, const char * restrict s2)

XDEF strcpy

strcpy:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strcpy.asm"
