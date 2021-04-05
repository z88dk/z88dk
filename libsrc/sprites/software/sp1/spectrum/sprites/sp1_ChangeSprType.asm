; void sp1_ChangeSprType(struct sp1_cs *c, void *drawf)
; CALLER linkage for function pointers

SECTION code_sprite_sp1
PUBLIC sp1_ChangeSprType

EXTERN sp1_ChangeSprType_callee
EXTERN ASMDISP_SP1_CHANGESPRTYPE_CALLEE

.sp1_ChangeSprType

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   jp sp1_ChangeSprType_callee + ASMDISP_SP1_CHANGESPRTYPE_CALLEE
