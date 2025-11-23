
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memccpy

EXTERN l0_memccpy_callee

_memccpy:

   pop af
   pop de
   pop hl
   exx
   pop bc
   exx
   pop bc
   
   push bc
   push bc
   push hl
   push de
   push af

   jp l0_memccpy_callee
