; wrapper for function pointers

PUBLIC fputs

EXTERN fputs_callee
EXTERN ASMDISP_FPUTS_CALLEE

.fputs

   pop de
   pop ix
   pop hl
   push hl
   push hl
   push de
   
   jp fputs_callee + ASMDISP_FPUTS_CALLEE
