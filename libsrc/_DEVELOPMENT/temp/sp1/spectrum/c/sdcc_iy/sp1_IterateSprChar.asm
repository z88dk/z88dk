; void sp1_IterateSprChar(struct sp1_ss *s, void *hook1)

XDEF _sp1_IterateSprChar

_sp1_IterateSprChar:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_IterateSprChar.asm"
