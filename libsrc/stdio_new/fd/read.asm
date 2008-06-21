; CALLER linkage for function pointers

XLIB read

LIB read_callee
XREF ASMDISP_READ_CALLEE

.read

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp read_callee + ASMDISP_READ_CALLEE
