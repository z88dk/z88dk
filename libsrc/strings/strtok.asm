; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strtok
PUBLIC _strtok
EXTERN strtok_callee
EXTERN ASMDISP_STRTOK_CALLEE

.strtok
._strtok

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp strtok_callee + ASMDISP_STRTOK_CALLEE

