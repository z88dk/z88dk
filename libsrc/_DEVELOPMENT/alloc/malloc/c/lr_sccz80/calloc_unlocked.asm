
; void *calloc_unlocked(size_t nmemb, size_t size)

XLIB calloc_unlocked

LIB asm_calloc_unlocked

calloc_unlocked:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   jp asm_calloc_unlocked
