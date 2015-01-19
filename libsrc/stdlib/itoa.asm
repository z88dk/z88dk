; CALLER linkage for function pointers

PUBLIC itoa
EXTERN itoa_callee
EXTERN ASMDISP_ITOA_CALLEE

.itoa

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp itoa_callee + ASMDISP_ITOA_CALLEE

