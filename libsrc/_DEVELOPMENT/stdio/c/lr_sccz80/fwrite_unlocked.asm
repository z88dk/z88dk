
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

XLIB fwrite_unlocked

LIB asm_fwrite_unlocked

fwrite_unlocked:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push ix
   push af
   
   jp asm_fwrite_unlocked
