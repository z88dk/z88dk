; CALLER linkage for function pointers

PUBLIC strtok
EXTERN strtok_callee
EXTERN ASMDISP_STRTOK_CALLEE

.strtok

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp strtok_callee + ASMDISP_STRTOK_CALLEE

