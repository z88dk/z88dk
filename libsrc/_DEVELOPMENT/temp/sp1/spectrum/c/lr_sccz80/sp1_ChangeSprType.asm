; void sp1_ChangeSprType(struct sp1_cs *c, void *drawf)

PUBLIC sp1_ChangeSprType

EXTERN asm_sp1_ChangeSprType

sp1_ChangeSprType:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_sp1_ChangeSprType
