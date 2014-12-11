
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

SECTION code_stdio

PUBLIC fread_unlocked_callee

fread_unlocked_callee:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_fread_unlocked.asm"
