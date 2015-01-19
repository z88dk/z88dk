; CALLER linkage for function pointers

PUBLIC ultoa

EXTERN ultoa_callee
EXTERN ASMDISP_ULTOA_CALLEE

.ultoa

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push de
   push hl
   push hl
   push bc
   push af

   jp ultoa_callee + ASMDISP_ULTOA_CALLEE
