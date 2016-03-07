; CALLER linkage for function pointers

SECTION code_clib
PUBLIC bcmp
PUBLIC _bcmp
EXTERN memcmp_callee
EXTERN ASMDISP_MEMCMP_CALLEE

.bcmp
._bcmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memcmp_callee + ASMDISP_MEMCMP_CALLEE
