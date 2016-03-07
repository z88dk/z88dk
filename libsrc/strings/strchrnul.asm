; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strchrnul
PUBLIC _strchrnul
EXTERN strchrnul_callee
EXTERN ASMDISP_STRCHRNUL_CALLEE

.strchrnul
._strchrnul

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp strchrnul_callee + ASMDISP_STRCHRNUL_CALLEE
