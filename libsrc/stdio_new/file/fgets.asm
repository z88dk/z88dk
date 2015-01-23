; wrapper for function pointers

PUBLIC fgets

EXTERN fgets_callee
EXTERN ASMDISP_FGETS_CALLEE

.fgets

   pop de
   pop ix
   pop bc
   pop hl
   push hl
   push bc
   push hl
   push de
   
   jp fgets_callee + ASMDISP_FGETS_CALLEE
