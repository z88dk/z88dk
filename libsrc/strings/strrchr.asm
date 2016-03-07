; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strrchr
PUBLIC _strrchr
EXTERN strrchr_callee
EXTERN ASMDISP_STRRCHR_CALLEE

.strrchr
._strrchr

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp strrchr_callee + ASMDISP_STRRCHR_CALLEE

