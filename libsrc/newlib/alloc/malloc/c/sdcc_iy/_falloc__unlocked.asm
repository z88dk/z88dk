
; void *_falloc__unlocked(void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __falloc__unlocked

EXTERN asm__falloc_unlocked

__falloc__unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm__falloc_unlocked
