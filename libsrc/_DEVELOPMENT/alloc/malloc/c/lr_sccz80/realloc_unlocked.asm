
; void *realloc_unlocked(void *p, size_t size)

XLIB realloc_unlocked

LIB asm_realloc_unlocked

realloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_realloc_unlocked
