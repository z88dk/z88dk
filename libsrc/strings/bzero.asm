; CALLER linkage for function pointers

PUBLIC bzero
EXTERN memset_callee
EXTERN ASMDISP_MEMSET_CALLEE

.bzero

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   ld e,0
      
   jp memset_callee + ASMDISP_MEMSET_CALLEE
