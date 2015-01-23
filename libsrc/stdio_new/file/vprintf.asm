; wrapper for function pointers

PUBLIC vprintf

EXTERN vfprintf_callee
EXTERN ASMDISP_VFPRINTF_CALLEE, _stdout

.vprintf

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   ld ix,(_stdout)
   jp vfprintf_callee + ASMDISP_VFPRINTF_CALLEE
