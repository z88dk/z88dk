
; size_t fread_unlocked_callee(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fread_unlocked_callee

EXTERN asm_fread_unlocked

_fread_unlocked_callee:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   push af
   
   jp asm_fread_unlocked
