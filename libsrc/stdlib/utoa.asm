; CALLER linkage for function pointers

XLIB utoa

LIB itoa_callee
XREF ASMDISP2_ITOA_CALLEE

.utoa

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   push hl
   jp itoa_callee + ASMDISP2_UTOA_CALLEE
