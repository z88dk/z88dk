; CALLER linkage for function pointers

SECTION code_clib
PUBLIC memchr
PUBLIC _memchr
EXTERN memchr_callee
EXTERN ASMDISP_MEMCHR_CALLEE

.memchr
._memchr

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp memchr_callee + ASMDISP_MEMCHR_CALLEE - 1
