; CALLER linkage for function pointers

PUBLIC labs
EXTERN labs_callee
EXTERN ASMDISP_LABS_CALLEE

.labs

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp labs_callee + ASMDISP_LABS_CALLEE
