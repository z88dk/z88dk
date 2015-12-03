
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fread_unlocked

EXTERN l0_fread_unlocked_callee

_fread_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   exx
   pop bc
   
   push bc
   push hl
   push bc
   push de
   push af

   jp l0_fread_unlocked_callee
