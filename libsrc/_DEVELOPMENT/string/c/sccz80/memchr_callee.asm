
; void *memchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memchr_callee, l0_memchr_callee

EXTERN asm_memchr

memchr_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

l0_memchr_callee:

   ld a,e
   
   jp asm_memchr
