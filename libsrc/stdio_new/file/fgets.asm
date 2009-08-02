; wrapper for function pointers

XLIB fgets

LIB fgets_callee
XREF ASMDISP_FGETS_CALLEE

.fgets

   pop de
   pop ix
   pop bc
   pop hl
   push hl
   push bc
   push hl
   push de
   
   jp fgets_callee + ASMDISP_FGETS_CALLEE
