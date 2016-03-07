; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strsep
PUBLIC _strsep
EXTERN strsep_callee
EXTERN ASMDISP_STRSEP_CALLEE

.strsep
._strsep

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp strsep_callee + ASMDISP_STRSEP_CALLEE

