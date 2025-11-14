
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fwrite_unlocked

EXTERN l0_fwrite_unlocked_callee

_fwrite_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   push de
   push bc
   push hl
   push af

   jp l0_fwrite_unlocked_callee
