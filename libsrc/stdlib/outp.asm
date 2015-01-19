; CALLER linkage for function pointers

PUBLIC outp
EXTERN outp_callee
EXTERN ASMDISP_OUTP_CALLEE

.outp

   pop af
   pop de
   pop bc
   push bc
   push de
   push af
   
   jp outp_callee + ASMDISP_OUTP_CALLEE
