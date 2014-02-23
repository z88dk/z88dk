
; size_t fread_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF fread_unlocked_callee

fread_unlocked_callee:

   pop af
   pop ix
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_fread_unlocked.asm"
