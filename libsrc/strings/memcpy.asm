; CALLER linkage for function pointers

SECTION code_clib
PUBLIC memcpy
PUBLIC _memcpy
EXTERN memcpy_callee
EXTERN ASMDISP_MEMCPY_CALLEE

.memcpy
._memcpy

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memcpy_callee + ASMDISP_MEMCPY_CALLEE
