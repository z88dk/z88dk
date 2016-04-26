; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strtoul
PUBLIC _strtoul
EXTERN strtol_callee
EXTERN ASMDISP_STRTOL_CALLEE

.strtoul
._strtoul

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strtol_callee + ASMDISP_STRTOL_CALLEE
