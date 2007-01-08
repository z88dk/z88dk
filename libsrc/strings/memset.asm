; CALLER linkage for function pointers

XLIB memset
LIB memset_callee
XREF ASMDISP_MEMSET_CALLEE

.memset

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memset_callee + ASMDISP_MEMSET_CALLEE

