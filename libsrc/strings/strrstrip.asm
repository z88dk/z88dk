; CALLER linkage for function pointers

XLIB strrstrip
LIB strrstrip_callee
XREF ASMDISP_STRRSTRIP_CALLEE

.strrstrip

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp strrstrip_callee + ASMDISP_STRRSTRIP_CALLEE

