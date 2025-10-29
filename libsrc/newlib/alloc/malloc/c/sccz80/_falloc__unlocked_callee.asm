
; void *_falloc__unlocked(void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _falloc__unlocked_callee

EXTERN asm__falloc_unlocked

_falloc__unlocked_callee:

   pop af
   pop hl
   pop bc
   push af

   jp asm__falloc_unlocked
