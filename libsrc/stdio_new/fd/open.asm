; CALLER linkage for function pointers

XLIB open

LIB open_callee
XREF ASMDISP_OPEN_CALLEE

.open

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp open_callee + ASMDISP_OPEN_CALLEE
