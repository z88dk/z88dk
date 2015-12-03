
; void *memchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memchr

EXTERN l0_memchr_callee

memchr:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp l0_memchr_callee
