; CALLER linkage for function pointers

XLIB memop
LIB memop_callee
XREF ASMDISP_MEMOP_CALLEE

.memop

   pop ix
   pop bc
   ld a,c
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push bc
   push ix
   
   jp memop_callee + ASMDISP_MEMOP_CALLEE
