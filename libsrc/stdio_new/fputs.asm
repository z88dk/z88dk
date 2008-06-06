; wrapper for function pointers

XLIB fputs

LIB fputs_callee
XREF ASMDISP_FPUTS_CALLEE

.fputs

   pop de
   pop ix
   pop hl
   push hl
   push hl
   push de
   
   jp fputs_callee + ASMDISP_FPUTS_CALLEE
