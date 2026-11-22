
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fread_unlocked

EXTERN asm_fread_unlocked

fread_unlocked:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push hl
   push af
   
   jp asm_fread_unlocked
