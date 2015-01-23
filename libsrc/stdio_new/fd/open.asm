; CALLER linkage for function pointers

PUBLIC open

EXTERN open_callee
EXTERN ASMDISP_OPEN_CALLEE

.open

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp open_callee + ASMDISP_OPEN_CALLEE
