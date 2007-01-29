; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)
; CALLER linkage for function pointers

XLIB sp1_IterateUpdateArr

LIB sp1_IterateUpdateArr_callee
XREF ASMDISP_SP1_ITERATEUPDATEARR_CALLEE

.sp1_IterateUpdateArr

   pop bc
   pop ix
   pop hl
   push hl
   push hl
   push bc
   jp sp1_IterateUpdateArr_callee + ASMDISP_SP1_ITERATEUPDATEARR_CALLEE
