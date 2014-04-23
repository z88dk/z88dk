; void sp1_ChangeSprType(struct sp1_cs *c, void *drawf)

XLIB sp1_ChangeSprType

LIB asm_sp1_ChangeSprType

sp1_ChangeSprType:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_sp1_ChangeSprType
