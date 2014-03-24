
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

XDEF fwrite_callee

fwrite_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fwrite.asm"
