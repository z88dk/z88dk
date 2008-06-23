; CALLER linkage for function pointers

XLIB poll

LIB poll_callee
XREF ASMDISP_POLL_CALLEE

.poll

   pop de
   pop bc
   pop bc
   pop hl
   push hl
   push bc
   push bc
   push de
   
   jp poll_callee + ASMDISP_POLL_CALLEE
