
; void *malloc_unlocked(size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _malloc_unlocked

EXTERN asm_malloc_unlocked

_malloc_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_malloc_unlocked
