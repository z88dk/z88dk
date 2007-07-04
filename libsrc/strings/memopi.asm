; CALLER linkage for function pointers

XLIB memopi
LIB memopi_callee
XREF ASMDISP_MEMOPI_CALLEE

.memopi

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
   
   jp memopi_callee + ASMDISP_MEMOPI_CALLEE
