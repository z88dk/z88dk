; CALLER linkage for function pointers

XLIB memcpy
LIB memcpy_callee
XREF ASMDISP_MEMCPY_CALLEE

.memcpy

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memcpy_callee + ASMDISP_MEMCPY_CALLEE
