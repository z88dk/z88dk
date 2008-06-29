; CALLER linkage for function pointers

XLIB utoa

LIB utoa_callee
XREF ASMDISP_UTOA_CALLEE

.utoa

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp utoa_callee + ASMDISP_UTOA_CALLEE

