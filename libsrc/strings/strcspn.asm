; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strcspn
PUBLIC _strcspn
EXTERN strcspn_callee
EXTERN ASMDISP_STRCSPN_CALLEE

.strcspn
._strcspn

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcspn_callee + ASMDISP_STRCSPN_CALLEE

