
; void *_falloc(void *p, size_t size)

XDEF _falloc_callee

_falloc_callee:

   pop af
   pop hl
   pop bc
   push af

   INCLUDE "../../z80/asm__falloc.asm"
