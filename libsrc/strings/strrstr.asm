; CALLER linkage for function pointers

PUBLIC strrstr
EXTERN strrstr_callee
EXTERN ASMDISP_STRRSTR_CALLEE

.strrstr

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strrstr_callee + ASMDISP_STRRSTR_CALLEE
