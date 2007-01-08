; CALLER linkage for function pointers

XLIB strpos
LIB strpos_callee
XREF ASMDISP_STRPOS_CALLEE

.strpos

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   
   jp strpos_callee + ASMDISP_STRPOS_CALLEE

