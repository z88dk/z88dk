; void sp1_ChangeSprType(struct sp1_cs *c, void *drawf)

XDEF _sp1_ChangeSprType

_sp1_ChangeSprType:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_ChangeSprType.asm"
