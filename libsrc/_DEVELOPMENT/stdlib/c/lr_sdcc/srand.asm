
; void srand(unsigned int seed)

XDEF srand

srand:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdlib/z80/asm_srand.asm"
