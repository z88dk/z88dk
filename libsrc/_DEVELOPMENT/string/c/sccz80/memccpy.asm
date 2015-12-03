
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memccpy

EXTERN l0_memccpy_callee

memccpy:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   
   push de
   push hl
   push ix
   push bc
   push af

   jp l0_memccpy_callee
