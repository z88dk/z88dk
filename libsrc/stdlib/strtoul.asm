; CALLER linkage for function pointers

PUBLIC strtoul
EXTERN strtol_callee
EXTERN ASMDISP_STRTOL_CALLEE

.strtoul

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp strtol_callee + ASMDISP_STRTOL_CALLEE
