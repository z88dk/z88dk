
; void *balloc_firstfit(unsigned int queue, unsigned char num)

SECTION code_alloc_balloc

PUBLIC _balloc_firstfit

_balloc_firstfit:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   ld a,c

   INCLUDE "alloc/balloc/z80/asm_balloc_firstfit.asm"
