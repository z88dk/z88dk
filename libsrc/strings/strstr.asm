; CALLER linkage for function pointers

PUBLIC strstr
EXTERN strstr_callee
EXTERN ASMDISP_STRSTR_CALLEE

.strstr

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp strstr_callee + ASMDISP_STRSTR_CALLEE
