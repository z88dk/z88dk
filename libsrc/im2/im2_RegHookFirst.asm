; CALLER linkage for function pointers

XLIB im2_RegHookFirst

LIB im2_RegHookFirst_callee
XREF ASMDISP_IM2_REGHOOKFIRST_CALLEE

.im2_RegHookFirst

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp im2_RegHookFirst_callee + ASMDISP_IM2_REGHOOKFIRST_CALLEE
