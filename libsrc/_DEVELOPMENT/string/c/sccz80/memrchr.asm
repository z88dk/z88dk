
; void *memrchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memrchr

EXTERN l0_memrchr_callee

memrchr:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp l0_memrchr_callee
