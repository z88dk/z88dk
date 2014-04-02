
; char *_memupr(void *p, size_t n)

XDEF __memupr

__memupr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "string/z80/asm__memupr.asm"

