; wrapper for function pointers

XLIB fputc
LIB fputc_callee
XREF ASMDISP_FPUTC_CALLEE

.fputc

   pop de
   pop ix
   pop hl
   push hl
   push hl
   push de
   
   jp fputc_callee + ASMDISP_FPUTC_CALLEE
