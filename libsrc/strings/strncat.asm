; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strncat
PUBLIC _strncat
EXTERN strncat_callee
EXTERN ASMDISP_STRNCAT_CALLEE

.strncat
._strncat

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strncat_callee + ASMDISP_STRNCAT_CALLEE

