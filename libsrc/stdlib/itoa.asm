; CALLER linkage for function pointers

XLIB itoa
LIB itoa_callee
XREF ASMDISP_ITOA_CALLEE

.itoa

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp itoa_callee + ASMDISP_ITOA_CALLEE

