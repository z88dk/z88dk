; CALLER linkage for function pointers

XLIB write

LIB write_callee
XREF ASMDISP_WRITE_CALLEE

.write

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp write_callee + ASMDISP_WRITE_CALLEE
