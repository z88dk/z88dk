; CALLER linkage for function pointers

PUBLIC memswap
EXTERN memswap_callee
EXTERN ASMDISP_MEMSWAP_CALLEE

.memswap

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memswap_callee + ASMDISP_MEMSWAP_CALLEE
