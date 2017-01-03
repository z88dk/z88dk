; CALLER linkage for function pointers

SECTION code_clib
PUBLIC outp
PUBLIC _outp
EXTERN outp_callee
EXTERN ASMDISP_OUTP_CALLEE

.outp
._outp

   pop af
   pop de
   pop bc
   push bc
   push de
   push af
   
   jp outp_callee + ASMDISP_OUTP_CALLEE
