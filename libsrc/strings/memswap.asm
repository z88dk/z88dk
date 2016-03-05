; CALLER linkage for function pointers

PUBLIC memswap
PUBLIC _memswap
EXTERN memswap_callee
EXTERN ASMDISP_MEMSWAP_CALLEE

.memswap
._memswap

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memswap_callee + ASMDISP_MEMSWAP_CALLEE
