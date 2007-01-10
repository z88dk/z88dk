; CALLER linkage for function pointers

XLIB outp
LIB outp_callee
XREF ASMDISP_OUTP_CALLEE

.outp

   pop af
   pop de
   pop bc
   push bc
   push de
   push af
   
   jp outp_callee + ASMDISP_OUTP_CALLEE
