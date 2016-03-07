; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strstrip
PUBLIC _strstrip
EXTERN strstrip_callee
EXTERN ASMDISP_STRSTRIP_CALLEE

.strstrip
._strstrip

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strstrip_callee + ASMDISP_STRSTRIP_CALLEE

