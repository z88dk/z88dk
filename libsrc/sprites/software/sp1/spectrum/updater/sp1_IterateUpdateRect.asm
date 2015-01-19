; void sp1_IterateUpdateRect(struct sp1_Rect *r, void *hook)
; CALLER linkage for function pointers

PUBLIC sp1_IterateUpdateRect

EXTERN sp1_IterateUpdateRect_callee
EXTERN CDISP_SP1_ITERATEUPDATERECT_CALLEE

.sp1_IterateUpdateRect

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   jp sp1_IterateUpdateRect_callee + CDISP_SP1_ITERATEUPDATERECT_CALLEE
