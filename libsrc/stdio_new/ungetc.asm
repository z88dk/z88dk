; wrapper for function pointers

XLIB ungetc
LIB ungetc_callee
XREF ASMDISP_UNGETC_CALLEE

.ungetc

   pop af
   pop ix
   pop hl
   push hl
   push hl
   push af
   
   jp ungetc_callee + ASMDISP_UNGETC_CALLEE
