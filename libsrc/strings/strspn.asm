; CALLER linkage for function pointers

XLIB strspn
LIB strspn_callee
XREF ASMDISP_STRSPN_CALLEE

.strspn

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strspn_callee + ASMDISP_STRSPN_CALLEE

