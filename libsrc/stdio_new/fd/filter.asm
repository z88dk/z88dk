; CALLER linkage for function pointers

XLIB filter

LIB filter_callee
XREF ASMDISP_FILTER_CALLEE

.filter

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp filter_callee + ASMDISP_FILTER_CALLEE
