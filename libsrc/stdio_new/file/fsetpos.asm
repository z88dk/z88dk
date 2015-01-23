; CALLER linkage for function pointers

PUBLIC fsetpos

EXTERN fsetpos_callee
EXTERN ASMDISP_FSETPOS_CALLEE

.fsetpos

   pop de
   pop hl
   pop ix
   push hl
   push hl
   push de
   
   jp fsetpos_callee + ASMDISP_FSETPOS_CALLEE
