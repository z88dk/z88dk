; CALLER linkage for function pointers

PUBLIC fgetpos

EXTERN fgetpos_callee
EXTERN ASMDISP_FGETPOS_CALLEE

.fgetpos

   pop de
   pop hl
   pop ix
   push hl
   push hl
   push de
   
   jp fgetpos_callee + ASMDISP_FGETPOS_CALLEE
