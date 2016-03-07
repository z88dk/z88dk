; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strrstr
PUBLIC _strrstr
EXTERN strrstr_callee
EXTERN ASMDISP_STRRSTR_CALLEE

.strrstr
._strrstr

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strrstr_callee + ASMDISP_STRRSTR_CALLEE
