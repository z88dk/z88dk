
; void *realloc_unlocked(void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC realloc_unlocked

EXTERN asm_realloc_unlocked

realloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_realloc_unlocked
