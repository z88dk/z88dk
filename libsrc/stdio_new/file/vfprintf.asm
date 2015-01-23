; wrapper for function pointers

PUBLIC vfprintf

EXTERN vfprintf_callee
EXTERN ASMDISP_VFPRINTF_CALLEE

.vfprintf

   pop hl
   pop bc
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
