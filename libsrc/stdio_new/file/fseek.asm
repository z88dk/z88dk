; CALLER linkage for function pointers

PUBLIC fseek

EXTERN fseek_callee
EXTERN ASMDISP_FSEEK_CALLEE

.fseek

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push de
   push de
   push hl
   push bc
   push af
   
   jp fseek_callee + ASMDISP_FSEEK_CALLEE
