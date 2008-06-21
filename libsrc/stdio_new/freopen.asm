; CALLER linkage for function pointers

XLIB freopen

LIB freopen_callee
XREF ASMDISP_FREOPEN_CALLEE

.freopen

   pop af
   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   push af
   
   jp freopen_callee + ASMDISP_FREOPEN_CALLEE
