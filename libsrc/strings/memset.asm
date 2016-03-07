; CALLER linkage for function pointers

SECTION code_clib
PUBLIC memset
PUBLIC _memset
EXTERN memset_callee
EXTERN ASMDISP_MEMSET_CALLEE

.memset
._memset

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memset_callee + ASMDISP_MEMSET_CALLEE

