
; void *_falloc__unlocked_callee(void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __falloc__unlocked_callee

EXTERN asm__falloc_unlocked

__falloc__unlocked_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm__falloc_unlocked
