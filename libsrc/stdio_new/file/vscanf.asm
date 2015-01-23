; wrapper for function pointers

PUBLIC vscanf

EXTERN vfscanf_callee
EXTERN ASMDISP_VFSCANF_CALLEE, _stdin

.vscanf

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   ld ix,(_stdin)
   jp vfscanf_callee + ASMDISP_VFSCANF_CALLEE
