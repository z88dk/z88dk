; CALLER linkage for function pointers

XLIB strcpy
LIB strcpy_callee
XREF ASMDISP_STRCPY_CALLEE

.strcpy

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp strcpy_callee + ASMDISP_STRCPY_CALLEE

