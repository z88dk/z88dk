; CALLER linkage for function pointers

XLIB strrstr
LIB strrstr_callee
XREF ASMDISP_STRRSTR_CALLEE

.strrstr

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strrstr_callee + ASMDISP_STRRSTR_CALLEE
