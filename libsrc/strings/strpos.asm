; CALLER linkage for function pointers

PUBLIC strpos
EXTERN strpos_callee
EXTERN ASMDISP_STRPOS_CALLEE

.strpos

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   
   jp strpos_callee + ASMDISP_STRPOS_CALLEE

