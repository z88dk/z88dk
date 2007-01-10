; CALLER linkage for function pointers

XLIB itoa
LIB itoa_callee
XREF ASMDISP_ITOA_CALLEE

.itoa

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp itoa_callee + ASMDISP_ITOA_CALLEE

