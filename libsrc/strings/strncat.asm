; CALLER linkage for function pointers

XLIB strncat
LIB strncat_callee
XREF ASMDISP_STRNCAT_CALLEE

.strncat

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp strncat_callee + ASMDISP_STRNCAT_CALLEE

