; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)
; CALLER linkage for function pointers

PUBLIC sp1_GetUpdateStruct

EXTERN sp1_GetUpdateStruct_callee
EXTERN ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_GetUpdateStruct

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   