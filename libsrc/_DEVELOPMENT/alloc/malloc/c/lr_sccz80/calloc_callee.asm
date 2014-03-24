
; void *calloc(size_t nmemb, size_t size)

XDEF calloc_callee

calloc_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_calloc.asm"
