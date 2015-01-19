; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)
; CALLER linkage for function pointers

PUBLIC sp1_IterateUpdateArr

EXTERN sp1_IterateUpdateArr_callee
EXTERN ASMDISP_SP1_ITERATEUPDATEARR_CALLEE

.sp1_IterateUpdateArr

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   jp sp1_IterateUpdateArr_callee + ASMDISP_SP1_ITERATEUPDATEARR_CALLEE
