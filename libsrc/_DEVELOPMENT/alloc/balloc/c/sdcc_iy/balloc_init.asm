
; void balloc_init(unsigned char num)

XDEF _balloc_init

_balloc_init:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/balloc/z80/asm_balloc_init.asm"
