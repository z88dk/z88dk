; CALLER linkage for function pointers

XLIB strncat
LIB strncat_callee
XREF ASMDISP_STRNCAT_CALLEE

.strncat

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strncat_callee + ASMDISP_STRNCAT_CALLEE

