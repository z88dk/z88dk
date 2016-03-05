; CALLER linkage for function pointers

PUBLIC strrstrip
PUBLIC _strrstrip
EXTERN strrstrip_callee
EXTERN ASMDISP_STRRSTRIP_CALLEE

.strrstrip
._strrstrip

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp strrstrip_callee + ASMDISP_STRRSTRIP_CALLEE

