
; void *_falloc(void *p, size_t size)

XDEF _falloc

_falloc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm__falloc.asm"
