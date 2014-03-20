
; void *_falloc_unlocked(void *p, size_t size)

XDEF _falloc_unlocked_callee

_falloc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af

   INCLUDE "../../z80/asm__falloc_unlocked.asm"
