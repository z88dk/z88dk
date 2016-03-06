; CALLER linkage for function pointers

SECTION code_clib
PUBLIC itoa
PUBLIC _itoa
EXTERN itoa_callee
EXTERN ASMDISP_ITOA_CALLEE

.itoa
._itoa

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp itoa_callee + ASMDISP_ITOA_CALLEE

