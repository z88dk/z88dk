; CALLER linkage for function pointers

SECTION code_clib
PUBLIC labs
PUBLIC _labs
EXTERN labs_callee
EXTERN ASMDISP_LABS_CALLEE

.labs
._labs

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp labs_callee + ASMDISP_LABS_CALLEE
