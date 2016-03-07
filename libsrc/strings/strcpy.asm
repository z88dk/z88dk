; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strcpy
PUBLIC _strcpy
EXTERN strcpy_callee
EXTERN ASMDISP_STRCPY_CALLEE

.strcpy
._strcpy

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp strcpy_callee + ASMDISP_STRCPY_CALLEE

