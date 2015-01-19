; CALLER linkage for function pointers

PUBLIC strsep
EXTERN strsep_callee
EXTERN ASMDISP_STRSEP_CALLEE

.strsep

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp strsep_callee + ASMDISP_STRSEP_CALLEE

