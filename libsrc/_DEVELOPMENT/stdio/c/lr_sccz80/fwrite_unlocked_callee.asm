
; size_t fwrite_unlocked(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF fwrite_unlocked_callee

fwrite_unlocked_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_fwrite_unlocked.asm"
