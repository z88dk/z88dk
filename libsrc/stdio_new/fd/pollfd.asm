; CALLER linkage for function pointers

PUBLIC pollfd

EXTERN pollfd_callee
EXTERN ASMDISP_POLLFD_CALLEE

.pollfd

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp pollfd_callee + ASMDISP_POLLFD_CALLEE
