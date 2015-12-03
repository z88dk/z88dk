; void __CALLEE__ sp1_ChangeSprType_callee(struct sp1_cs *c, void *drawf)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ChangeSprType_callee

EXTERN asm_sp1_ChangeSprType

sp1_ChangeSprType_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_sp1_ChangeSprType
