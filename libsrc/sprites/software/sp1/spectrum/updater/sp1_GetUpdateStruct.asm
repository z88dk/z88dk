; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB sp1_GetUpdateStruct

LIB sp1_GetUpdateStruct_callee
XREF ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_GetUpdateStruct

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_GetUpdateStruct_callee + ASMDISP_SP1_GETUPDATESTRUCT_CALLEE
   