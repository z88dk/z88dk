; CALLER linkage for function pointers

XLIB memrchr
LIB memrchr_callee
XREF ASMDISP_MEMRCHR_CALLEE

.memrchr

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memrchr_callee + ASMDISP_MEMRCHR_CALLEE - 1
