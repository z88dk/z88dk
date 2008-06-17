; CALLER linkage for function pointers

XLIB fopen

LIB fopen_callee
XREF ASMDISP_FOPEN_CALLEE

.fopen

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp fopen_callee + ASMDISP_FOPEN_CALLEE
