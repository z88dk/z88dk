
; void *calloc_unlocked(size_t nmemb, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC calloc_unlocked

EXTERN asm_calloc_unlocked

calloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_calloc_unlocked
