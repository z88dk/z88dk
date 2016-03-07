; CALLER linkage for function pointers

SECTION code_clib
PUBLIC bcopy
PUBLIC _bcopy
EXTERN memcpy_callee
EXTERN ASMDISP_MEMCPY_CALLEE

.bcopy
._bcopy

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp memcpy_callee + ASMDISP_MEMCPY_CALLEE
