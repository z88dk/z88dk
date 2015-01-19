; CALLER linkage for function pointers

PUBLIC strcat
EXTERN strcat_callee
EXTERN ASMDISP_STRCAT_CALLEE

.strcat

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcat_callee + ASMDISP_STRCAT_CALLEE

