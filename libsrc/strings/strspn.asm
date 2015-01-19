; CALLER linkage for function pointers

PUBLIC strspn
EXTERN strspn_callee
EXTERN ASMDISP_STRSPN_CALLEE

.strspn

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strspn_callee + ASMDISP_STRSPN_CALLEE

