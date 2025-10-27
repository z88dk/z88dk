
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fwrite_unlocked

EXTERN asm_fwrite_unlocked

_fwrite_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   pop ix
   
   push hl
   push de
   push bc
   push hl
   push af

   jp asm_fwrite_unlocked
