; CALLER linkage for function pointers

XLIB pollfd

LIB pollfd_callee
XREF ASMDISP_POLLFD_CALLEE

.pollfd

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp pollfd_callee + ASMDISP_POLLFD_CALLEE
