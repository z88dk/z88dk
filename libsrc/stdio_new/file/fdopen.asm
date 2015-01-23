; CALLER linkage for function pointers
; 06.2008 aralbrec

PUBLIC fdopen

EXTERN fdopen_callee
EXTERN ASMDISP_FDOPEN_CALLEE

.fdopen

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp fdopen_callee + ASMDISP_FDOPEN_CALLEE
