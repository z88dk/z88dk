; CALLER linkage for function pointers

PUBLIC bcmp
EXTERN memcmp_callee
EXTERN ASMDISP_MEMCMP_CALLEE

.bcmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memcmp_callee + ASMDISP_MEMCMP_CALLEE
