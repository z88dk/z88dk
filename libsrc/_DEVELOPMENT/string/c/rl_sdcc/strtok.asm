
; char *strtok(char * restrict s1, const char * restrict s2)

XDEF strtok

strtok:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_strtok.asm"
