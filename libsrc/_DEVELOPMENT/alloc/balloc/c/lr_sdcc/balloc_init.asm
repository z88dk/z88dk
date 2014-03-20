
; void balloc_init(unsigned char num)

XDEF balloc_init

balloc_init:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_balloc_init.asm"
