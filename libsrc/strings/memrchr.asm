; CALLER linkage for function pointers

SECTION code_clib
PUBLIC memrchr
PUBLIC _memrchr
EXTERN memrchr_callee
EXTERN ASMDISP_MEMRCHR_CALLEE

.memrchr
._memrchr

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memrchr_callee + ASMDISP_MEMRCHR_CALLEE - 1
