; CALLER linkage for function pointers

PUBLIC fopen

EXTERN fopen_callee
EXTERN ASMDISP_FOPEN_CALLEE

.fopen

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp fopen_callee + ASMDISP_FOPEN_CALLEE
