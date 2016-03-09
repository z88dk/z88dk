; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_RegHookFirst
PUBLIC _im2_RegHookFirst

EXTERN im2_RegHookFirst_callee
EXTERN ASMDISP_IM2_REGHOOKFIRST_CALLEE

.im2_RegHookFirst
._im2_RegHookFirst

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp im2_RegHookFirst_callee + ASMDISP_IM2_REGHOOKFIRST_CALLEE
