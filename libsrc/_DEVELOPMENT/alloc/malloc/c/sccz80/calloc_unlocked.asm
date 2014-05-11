
; void *calloc_unlocked(size_t nmemb, size_t size)

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
