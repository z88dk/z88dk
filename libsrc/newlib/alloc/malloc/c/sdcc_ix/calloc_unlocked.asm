
; void *calloc_unlocked(size_t nmemb, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _calloc_unlocked

EXTERN asm_calloc_unlocked

_calloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_calloc_unlocked
