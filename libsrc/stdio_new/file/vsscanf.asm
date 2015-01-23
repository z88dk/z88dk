; wrapper for function pointers

PUBLIC vsscanf

EXTERN vsscanf_callee
EXTERN ASMDISP_VSSCANF_CALLEE

.vsscanf

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
   
   jp vsscanf_callee + ASMDISP_VSSCANF_CALLEE
