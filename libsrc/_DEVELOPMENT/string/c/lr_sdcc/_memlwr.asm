
; char *_memlwr(void *p, size_t n)

XDEF _memlwr

_memlwr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm__memlwr.asm"

