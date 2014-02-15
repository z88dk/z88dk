
; char *stpcpy(char * restrict s1, const char * restrict s2)

XDEF stpcpy

stpcpy:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_stpcpy.asm"
