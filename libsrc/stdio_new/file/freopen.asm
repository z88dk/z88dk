; CALLER linkage for function pointers

PUBLIC freopen

EXTERN freopen_callee
EXTERN ASMDISP_FREOPEN_CALLEE

.freopen

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp freopen_callee + ASMDISP_FREOPEN_CALLEE
