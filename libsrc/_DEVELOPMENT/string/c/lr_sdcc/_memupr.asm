
; char *_memupr(void *p, size_t n)

XDEF _memupr

_memupr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm__memupr.asm"

