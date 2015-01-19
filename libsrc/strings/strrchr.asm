; CALLER linkage for function pointers

PUBLIC strrchr
EXTERN strrchr_callee
EXTERN ASMDISP_STRRCHR_CALLEE

.strrchr

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp strrchr_callee + ASMDISP_STRRCHR_CALLEE

