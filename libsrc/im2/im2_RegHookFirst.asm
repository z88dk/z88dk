; CALLER linkage for function pointers

PUBLIC im2_RegHookFirst

EXTERN im2_RegHookFirst_callee
EXTERN ASMDISP_IM2_REGHOOKFIRST_CALLEE

.im2_RegHookFirst

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp im2_RegHookFirst_callee + ASMDISP_IM2_REGHOOKFIRST_CALLEE
