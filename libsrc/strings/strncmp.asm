; CALLER linkage for function pointers

PUBLIC strncmp
EXTERN strncmp_callee
EXTERN ASMDISP_STRNCMP_CALLEE

.strncmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strncmp_callee + ASMDISP_STRNCMP_CALLEE

