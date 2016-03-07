; CALLER linkage for function pointers

SECTION code_clib
PUBLIC bzero
PUBLIC _bzero
EXTERN memset_callee
EXTERN ASMDISP_MEMSET_CALLEE

.bzero
._bzero

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   ld e,0
      
   jp memset_callee + ASMDISP_MEMSET_CALLEE
