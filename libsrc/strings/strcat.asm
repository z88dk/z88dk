; CALLER linkage for function pointers

XLIB strcat
LIB strcat_callee
XREF ASMDISP_STRCAT_CALLEE

.strcat

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcat_callee + ASMDISP_STRCAT_CALLEE

