; CALLER linkage for function pointers

PUBLIC strlcat

EXTERN strlcat_callee
EXTERN ASMDISP_STRLCAT_CALLEE

.strlcat

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strlcat_callee + ASMDISP_STRLCAT_CALLEE
