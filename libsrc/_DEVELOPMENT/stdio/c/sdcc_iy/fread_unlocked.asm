
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fread_unlocked

EXTERN asm_fread_unlocked

_fread_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   
   push hl
   push hl
   push bc
   push de
   push af
   
   jp asm_fread_unlocked
