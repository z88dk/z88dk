; CALLER linkage for function pointers

XLIB strtok
LIB strtok_callee
XREF ASMDISP_STRTOK_CALLEE

.strtok

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp strtok_callee + ASMDISP_STRTOK_CALLEE

