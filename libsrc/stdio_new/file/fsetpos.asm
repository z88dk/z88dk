; CALLER linkage for function pointers

XLIB fsetpos

LIB fsetpos_callee
XREF ASMDISP_FSETPOS_CALLEE

.fsetpos

   pop de
   pop hl
   pop ix
   push hl
   push hl
   push de
   
   jp fsetpos_callee + ASMDISP_FSETPOS_CALLEE
