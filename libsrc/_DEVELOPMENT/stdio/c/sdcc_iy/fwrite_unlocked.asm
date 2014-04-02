
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF _fwrite_unlocked

_fwrite_unlocked:

   pop af
   pop hl
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push hl
   push af

   INCLUDE "stdio/z80/asm_fwrite_unlocked.asm"
