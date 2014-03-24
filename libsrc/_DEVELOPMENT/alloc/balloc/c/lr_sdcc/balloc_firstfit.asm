
; void *balloc_firstfit(unsigned int queue, unsigned char num)

XDEF balloc_firstfit

balloc_firstfit:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,c

   INCLUDE "alloc/balloc/z80/asm_balloc_firstfit.asm"
