
; void *realloc_unlocked(void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _realloc_unlocked

EXTERN asm_realloc_unlocked

_realloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_realloc_unlocked
