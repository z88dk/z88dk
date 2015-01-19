; CALLER linkage for function pointers

PUBLIC strchrnul
EXTERN strchrnul_callee
EXTERN ASMDISP_STRCHRNUL_CALLEE

.strchrnul

   pop af
   pop bc
   pop hl
   push hl
   push bc
   push af
   
   jp strchrnul_callee + ASMDISP_STRCHRNUL_CALLEE
