; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strstr
PUBLIC _strstr
EXTERN strstr_callee
EXTERN ASMDISP_STRSTR_CALLEE

.strstr
._strstr

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp strstr_callee + ASMDISP_STRSTR_CALLEE
