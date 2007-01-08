; CALLER linkage for function pointers

XLIB strcspn
LIB strcspn_callee
XREF ASMDISP_STRCSPN_CALLEE

.strcspn

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcspn_callee + ASMDISP_STRCSPN_CALLEE

