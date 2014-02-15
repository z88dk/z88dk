
; char *_memlwr(void *p, size_t n)

XDEF _memlwr

_memlwr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
      
   INCLUDE "../../z80/asm__memlwr.asm"

