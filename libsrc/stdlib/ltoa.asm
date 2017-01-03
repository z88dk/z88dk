; CALLER linkage for function pointers

PUBLIC ltoa
PUBLIC _ltoa

EXTERN ltoa_callee
EXTERN ASMDISP_LTOA_CALLEE

.ltoa
._ltoa

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push de
   push hl
   push hl
   push bc
   push af
   
   jp ltoa_callee + ASMDISP_LTOA_CALLEE
