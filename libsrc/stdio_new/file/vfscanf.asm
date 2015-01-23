; wrapper for function pointers

PUBLIC vfscanf

EXTERN vfscanf_callee
EXTERN ASMDISP_VFSCANF_CALLEE

.vfscanf

   pop hl
   pop bc
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp vfscanf_callee + ASMDISP_VFSCANF_CALLEE
