; CALLER linkage for function pointers

SECTION code_clib
PUBLIC utoa
PUBLIC _utoa

EXTERN utoa_callee
EXTERN ASMDISP_UTOA_CALLEE

.utoa
._utoa

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp utoa_callee + ASMDISP_UTOA_CALLEE

