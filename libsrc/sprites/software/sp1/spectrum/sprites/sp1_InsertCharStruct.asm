; void sp1_InsertCharStruct(struct sp1_update *u, struct sp1_cs *cs)
; CALLER linkage for function pointers

PUBLIC sp1_InsertCharStruct

EXTERN sp1_InsertCharStruct_callee
EXTERN ASMDISP_SP1_INSERTCHARSTRUCT_CALLEE

.sp1_InsertCharStruct

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   jp sp1_InsertCharStruct_callee + ASMDISP_SP1_INSERTCHARSTRUCT_CALLEE
