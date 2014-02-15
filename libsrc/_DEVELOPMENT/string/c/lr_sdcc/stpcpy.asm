
; char *stpcpy(char * restrict s1, const char * restrict s2)

XDEF stpcpy

stpcpy:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_stpcpy.asm"
