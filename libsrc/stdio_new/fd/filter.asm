; CALLER linkage for function pointers

PUBLIC filter

EXTERN filter_callee
EXTERN ASMDISP_FILTER_CALLEE

.filter

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp filter_callee + ASMDISP_FILTER_CALLEE
