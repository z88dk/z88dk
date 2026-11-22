; void sp1_ChangeSprType(struct sp1_cs *c, void *drawf)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_ChangeSprType

EXTERN asm_sp1_ChangeSprType

_sp1_ChangeSprType:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_sp1_ChangeSprType
