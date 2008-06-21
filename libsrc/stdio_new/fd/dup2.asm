; CALLER linkage for function pointers

XLIB dup2

LIB dup2_callee
XREF ASMDISP_DUP2_CALLEE

.dup2

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp dup2_callee + ASMDISP_DUP2_CALLEE
