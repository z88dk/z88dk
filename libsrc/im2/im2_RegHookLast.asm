; CALLER linkage for function pointers

PUBLIC im2_RegHookLast

EXTERN im2_RegHookLast_callee
EXTERN ASMDISP_IM2_REGHOOKLAST_CALLEE

.im2_RegHookLast

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp im2_RegHookLast_callee + ASMDISP_IM2_REGHOOKLAST_CALLEE
