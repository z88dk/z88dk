; CALLER linkage for function pointers

PUBLIC dup2

EXTERN dup2_callee
EXTERN ASMDISP_DUP2_CALLEE

.dup2

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp dup2_callee + ASMDISP_DUP2_CALLEE
