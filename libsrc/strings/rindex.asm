; CALLER linkage for function pointers

PUBLIC rindex
EXTERN strrchr_callee
EXTERN ASMDISP_STRRCHR_CALLEE

.rindex

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp strrchr_callee + ASMDISP_STRRCHR_CALLEE
