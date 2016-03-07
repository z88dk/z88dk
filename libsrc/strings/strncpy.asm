; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strncpy
PUBLIC _strncpy
EXTERN strncpy_callee
EXTERN ASMDISP_STRNCPY_CALLEE

.strncpy
._strncpy

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp strncpy_callee + ASMDISP_STRNCPY_CALLEE

