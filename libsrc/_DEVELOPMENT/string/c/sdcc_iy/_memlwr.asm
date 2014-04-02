
; char *_memlwr(void *p, size_t n)

XDEF __memlwr

__memlwr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
      
   INCLUDE "string/z80/asm__memlwr.asm"

