; CALLER linkage for function pointers

XLIB memswap
LIB memswap_callee
XREF ASMDISP_MEMSWAP_CALLEE

.memswap

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memswap_callee + ASMDISP_MEMSWAP_CALLEE
