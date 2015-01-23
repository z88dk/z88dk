; wrapper for function pointers

PUBLIC ungetc
EXTERN ungetc_callee
EXTERN ASMDISP_UNGETC_CALLEE

.ungetc

   pop af
   pop ix
   pop hl
   push hl
   push hl
   push af
   
   jp ungetc_callee + ASMDISP_UNGETC_CALLEE
