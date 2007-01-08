; CALLER linkage for function pointers

XLIB strncpy
LIB strncpy_callee
XREF ASMDISP_STRNCPY_CALLEE

.strncpy

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp strncpy_callee + ASMDISP_STRNCPY_CALLEE

