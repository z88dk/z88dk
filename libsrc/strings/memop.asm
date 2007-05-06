; CALLER linkage for function pointers

XLIB memop
LIB memop_callee
XREF ASMDISP_MEMOP_CALLEE

.memop

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push bc
   push af
   
   jp memop_callee + ASMDISP_MEMOP_CALLEE
