; wrapper for function pointers

PUBLIC vsnprintf

EXTERN vsnprintf_callee
EXTERN ASMDISP_VSNPRINTF_CALLEE

.vsnprintf

   pop hl
   pop bc
   pop de
   exx
   pop de
   pop hl
   push hl
   push de
   exx
   push de
   push bc
   push hl
   
   jp vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE
