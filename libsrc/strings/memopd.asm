; CALLER linkage for function pointers

XLIB memopd
LIB memopd_callee
XREF ASMDISP_MEMOPD_CALLEE

.memopd

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
   
   jp memopd_callee + ASMDISP_MEMOPD_CALLEE
