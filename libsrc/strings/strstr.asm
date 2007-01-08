; CALLER linkage for function pointers

XLIB strstr
LIB strstr_callee
XREF ASMDISP_STRSTR_CALLEE

.strstr

   pop af
   pop hl
   pop de
   push de
   push hl
   push af
   
   jp strstr_callee + ASMDISP_STRSTR_CALLEE
