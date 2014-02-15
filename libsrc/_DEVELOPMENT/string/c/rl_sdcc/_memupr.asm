
; char *_memupr(void *p, size_t n)

XDEF _memupr

_memupr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm__memupr.asm"

