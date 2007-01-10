; CALLER linkage for function pointers

XLIB labs
LIB labs_callee
XREF ASMDISP_LABS_CALLEE

.labs

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp labs_callee + ASMDISP_LABS_CALLEE
