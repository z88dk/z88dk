; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strpos
PUBLIC _strpos
EXTERN strpos_callee
EXTERN ASMDISP_STRPOS_CALLEE

.strpos
._strpos

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   
   jp strpos_callee + ASMDISP_STRPOS_CALLEE

