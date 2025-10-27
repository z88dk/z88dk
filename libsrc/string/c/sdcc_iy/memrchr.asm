
; void *memrchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memrchr

EXTERN l0_memrchr_callee

_memrchr:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_memrchr_callee
