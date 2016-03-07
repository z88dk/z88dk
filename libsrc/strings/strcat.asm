; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strcat
PUBLIC _strcat
EXTERN strcat_callee
EXTERN ASMDISP_STRCAT_CALLEE

.strcat
._strcat

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcat_callee + ASMDISP_STRCAT_CALLEE

