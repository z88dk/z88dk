
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION seg_code_stdio

PUBLIC _fread_unlocked

_fread_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   
   push ix
   push hl
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_fread_unlocked.asm"
