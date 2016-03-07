; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strlcat
PUBLIC _strlcat

EXTERN strlcat_callee
EXTERN ASMDISP_STRLCAT_CALLEE

.strlcat
._strlcat

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strlcat_callee + ASMDISP_STRLCAT_CALLEE
