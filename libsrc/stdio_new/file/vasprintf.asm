; wrapper for function pointers

PUBLIC vasprintf

EXTERN vasprintf_callee
EXTERN ASMDISP_VASPRINTF_CALLEE

.vasprintf

   pop hl
   pop bc
   pop de
   exx
   pop hl
   ld de,0
   push hl
   exx
   push de
   push bc
   push hl
   
   jp vasprintf_callee + ASMDISP_VASPRINTF_CALLEE
