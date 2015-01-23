; wrapper for function pointers

PUBLIC fputc

EXTERN fputc_callee
EXTERN ASMDISP_FPUTC_CALLEE

.fputc

   pop de
   pop ix
   pop hl
   push hl
   push hl
   push de
   
   jp fputc_callee + ASMDISP_FPUTC_CALLEE
