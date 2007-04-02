; CALLER linkage for function pointers

XLIB ultoa

LIB ltoa_callee
XREF ASMDISP2_LTOA_CALLEE

.ultoa

   pop af
   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push af
   
   push bc
   jp ltoa_callee + ASMDISP2_LTOA_CALLEE
