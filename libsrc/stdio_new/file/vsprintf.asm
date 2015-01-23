; wrapper for function pointers

PUBLIC vsprintf

EXTERN vsprintf_callee
EXTERN ASMDISP_VSPRINTF_CALLEE

.vsprintf

   pop hl
   pop bc
   pop de
   exx
   pop hl
   push hl
   exx
   push de
   push bc
   push hl
   
   jp vsprintf_callee + ASMDISP_VSPRINTF_CALLEE
