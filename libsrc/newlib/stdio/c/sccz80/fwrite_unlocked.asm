
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fwrite_unlocked

EXTERN asm_fwrite_unlocked

fwrite_unlocked:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push hl
   push af
   
   jp asm_fwrite_unlocked
