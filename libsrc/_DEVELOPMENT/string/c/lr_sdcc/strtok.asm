
; char *strtok(char * restrict s1, const char * restrict s2)

XDEF strtok

strtok:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_strtok.asm"
