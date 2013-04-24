; CALLER linkage for function pointers

XLIB strsep
LIB strsep_callee
XREF ASMDISP_STRSEP_CALLEE

.strsep

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp strsep_callee + ASMDISP_STRSEP_CALLEE

