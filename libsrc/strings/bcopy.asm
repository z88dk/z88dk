; CALLER linkage for function pointers

XLIB bcopy
LIB memcpy_callee
XREF ASMDISP_MEMCPY_CALLEE

.bcopy

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp memcpy_callee + ASMDISP_MEMCPY_CALLEE
