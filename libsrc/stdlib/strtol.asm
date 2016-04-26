; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strtol
PUBLIC _strtol
EXTERN strtol_callee
EXTERN ASMDISP_STRTOL_CALLEE

.strtol
._strtol

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strtol_callee + ASMDISP_STRTOL_CALLEE
