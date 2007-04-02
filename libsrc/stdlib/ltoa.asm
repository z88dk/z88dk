; CALLER linkage for function pointers

XLIB ltoa

LIB ltoa_callee
XREF ASMDISP_LTOA_CALLEE

.ltoa

   pop af
   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push af
   
   jp ltoa_callee + ASMDISP_LTOA_CALLEE
