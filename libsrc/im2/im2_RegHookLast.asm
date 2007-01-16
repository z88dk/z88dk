; CALLER linkage for function pointers

XLIB im2_RegHookLast

LIB im2_RegHookLast_callee
XREF ASMDISP_IM2_REGHOOKLAST_CALLEE

.im2_RegHookLast

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   jp im2_RegHookLast_callee + ASMDISP_IM2_REGHOOKLAST_CALLEE
